package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.note.Note;
import ar.edu.itba.paw.models.note.NoteFile;
import ar.edu.itba.paw.models.note.Review;
import ar.edu.itba.paw.models.search.SortArguments;
import ar.edu.itba.paw.models.user.User;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface NoteDao {
    UUID create(String name, UUID subjectId, User user, UUID parentId, boolean visible, byte[] file, String category, String fileType);

    Optional<NoteFile> getNoteFileById(UUID noteId, UUID currentUserId);

    Optional<Note> getNoteById(UUID noteId, UUID currentUserId);

    boolean delete(List<UUID> noteId);

    boolean delete(List<UUID> noteIds, UUID currentUserId);

    int countReviews(UUID noteId);

    int countReviewsByUser(UUID userId);

    List<Review> getReviewsByUser(UUID userId, int pageNum, int pageSize);

    List<Review> getReviews(UUID noteId, int pageNum);

    List<Review> getReviews(UUID noteId, int pageNum, int pageSize);

    /**
     * @param noteId Id of the note
     * @param currentUserId Id of the current user
     * @return List of reviews of the note with id noteId, ordered by date, with a limit of REVIEW_LIMIT.
     * If the current user has a review, it will be the first element of the list
     */
    List<Review> getFirstReviews(UUID noteId, UUID currentUserId);

    boolean deleteReview(UUID noteId, UUID userId);

    Review getReview(UUID noteId, UUID userId);

    Review createOrUpdateReview(Note note, User user, int score, String content);

    void addFavorite(User user, UUID noteId);

    boolean removeFavorite(User user, UUID noteId);

    List<Note> findNotesByIds(List<UUID> noteIds);

    List<Note> findNotesByIds(List<UUID> noteIds, UUID currentUserId, SortArguments sa);

    void loadNoteFavorites(List<UUID> noteIds, UUID currentUserId);

    void addInteractionIfNotExists(User user, Note note);
}