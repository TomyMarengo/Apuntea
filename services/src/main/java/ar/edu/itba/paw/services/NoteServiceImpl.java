package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Category;
import ar.edu.itba.paw.models.Page;
import ar.edu.itba.paw.models.directory.Directory;
import ar.edu.itba.paw.models.exceptions.InvalidFileException;
import ar.edu.itba.paw.models.exceptions.directory.InvalidDirectoryException;
import ar.edu.itba.paw.models.exceptions.note.InvalidNoteException;
import ar.edu.itba.paw.models.exceptions.note.InvalidReviewException;
import ar.edu.itba.paw.models.exceptions.note.NoteNotFoundException;
import ar.edu.itba.paw.models.institutional.Subject;
import ar.edu.itba.paw.models.note.Note;
import ar.edu.itba.paw.models.note.NoteFile;
import ar.edu.itba.paw.models.note.Review;
import ar.edu.itba.paw.models.user.User;
import ar.edu.itba.paw.persistence.DirectoryDao;
import ar.edu.itba.paw.persistence.NoteDao;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class NoteServiceImpl implements NoteService {
    private final NoteDao noteDao;
    private final DirectoryDao directoryDao;
    private final EmailService emailService;
    private final SecurityService securityService;


    @Autowired
    public NoteServiceImpl(final NoteDao noteDao, final DirectoryDao directoryDao, final SecurityService securityService, final EmailService emailService) {
        this.noteDao = noteDao;
        this.securityService = securityService;
        this.emailService = emailService;
        this.directoryDao = directoryDao;
    }

    @Transactional
    @Override
    public UUID createNote(String name, UUID parentId, boolean visible, MultipartFile file, String category) {
        User user = securityService.getCurrentUserOrThrow();
        Directory rootDir = directoryDao.getDirectoryRoot(parentId).orElseThrow(InvalidDirectoryException::new);

        byte[] fileBytes;
        try {
            fileBytes = file.getBytes();
        } catch (IOException e) {
            throw new InvalidFileException();
        }
        Subject subject = rootDir.getSubject();
        return noteDao.create(name, subject.getSubjectId(), user, parentId, visible, fileBytes, category, FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase());
    }

    @Transactional
    @Override
    public Optional<Note> getNoteById(UUID noteId) {
        final Optional<User> maybeUser = securityService.getCurrentUser();
        Optional<Note> note = noteDao.getNoteById(noteId, maybeUser.map(User::getUserId).orElse(null));
        if (note.isPresent() && maybeUser.isPresent()) {
            noteDao.loadNoteFavorites(Collections.singletonList(note.get().getId()), maybeUser.get().getUserId());
            noteDao.addInteractionIfNotExists(maybeUser.get(), note.get());
        }
        return note;
    }

    @Transactional
    @Override
    public Optional<NoteFile> getNoteFileById(UUID noteId) {
        final UUID userId = securityService.getCurrentUser().map(User::getUserId).orElse(null);
        return noteDao.getNoteFileById(noteId, userId);
    }

    @Transactional
    @Override
    public void update(UUID noteId, String name, boolean visible, String category) {
        Note note = noteDao.getNoteById(noteId, securityService.getCurrentUserOrThrow().getUserId()).orElseThrow(InvalidNoteException::new);
        note.setName(name);
        note.setVisible(visible);
        note.setCategory(Category.valueOf(category.toUpperCase()));
        note.setLastModifiedAt(LocalDateTime.now());
    }


    @Transactional
    @Override
    public void delete(UUID[] noteIds, String reason) {
        if (noteIds.length == 0) return;

        List<UUID> noteIdsList = Arrays.asList(noteIds);

        User currentUser = securityService.getCurrentUserOrThrow();
        if (!currentUser.getIsAdmin()) {
            if (!noteDao.delete(noteIdsList, currentUser.getUserId()))
                throw new InvalidNoteException();
        } else {
            List<Note> notes = noteDao.findNotesByIds(noteIdsList);
            if (notes.size() != noteIdsList.size() || !noteDao.delete(noteIdsList)) throw new InvalidNoteException();
            notes.forEach(n -> emailService.sendDeleteNoteEmail(n, reason));
        }
    }

    @Transactional
    @Override
    public List<Review> getReviews(UUID noteId) {
        Optional<User> maybeUser = securityService.getCurrentUser();
        if (maybeUser.isPresent())
            return noteDao.getFirstReviews(noteId, maybeUser.get().getUserId());
        return noteDao.getReviews(noteId, 1);
    }

    @Transactional
    @Override
    public Page<Review> getPaginatedReviews(UUID note, int pageNum, int pageSize) {
        this.noteDao.getNoteById(note,
                securityService.getCurrentUser().map(User::getUserId).orElse(null)
        ).orElseThrow(NoteNotFoundException::new);

        int countTotalResults = noteDao.countReviews(note);
        int safePage = Page.getSafePagePosition(pageNum, countTotalResults, pageSize);

        return new Page<>(
                noteDao.getReviews(note, safePage, pageSize),
                safePage,
                pageSize,
                countTotalResults
        );
    }

    @Transactional
    @Override
    public Page<Review> getPaginatedReviewsByUser(UUID user, int pageNum, int pageSize) {
        int countTotalResults = noteDao.countReviewsByUser(user);
        int safePage = Page.getSafePagePosition(pageNum, countTotalResults, pageSize);

        return new Page<>(
                noteDao.getReviewsByUser(user, safePage, pageSize),
                safePage,
                pageSize,
                countTotalResults
        );
    }

    @Transactional
    @Override
    public void createOrUpdateReview(UUID noteId, int score, String content) {
        User user = securityService.getCurrentUserOrThrow();
        Note note = noteDao.getNoteById(noteId, user.getUserId()).orElseThrow(NoteNotFoundException::new);
        if (note.getUser().equals(user))
            throw new InvalidReviewException();
        Review review = noteDao.createOrUpdateReview(note, user, score, content);
        emailService.sendReviewEmail(review);
    }

    @Transactional
    @Override
    public void deleteReview(UUID noteId, UUID userId, String reason) {
        Review review = noteDao.getReview(noteId, userId);
        if (!noteDao.deleteReview(noteId, userId)) throw new InvalidReviewException();
        emailService.sendDeleteReviewEmail(review, reason);
    }

    @Transactional
    @Override
    public Collection<Note> getFavorites() {
        User currentUser = securityService.getCurrentUserOrThrow();
        return currentUser.getNoteFavorites();
    }

    @Transactional
    @Override
    public void addFavorite(UUID noteId) {
        User currentUser = securityService.getCurrentUserOrThrow();
        noteDao.addFavorite(currentUser, noteId);
    }

    @Transactional
    @Override
    public void removeFavorite(UUID noteId) {
        User currentUser = securityService.getCurrentUserOrThrow();
        boolean success = noteDao.removeFavorite(currentUser, noteId);
        if (!success) throw new InvalidNoteException();
    }
}
