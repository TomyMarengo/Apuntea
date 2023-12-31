package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.models.*;
import ar.edu.itba.paw.models.directory.Directory;
import ar.edu.itba.paw.models.exceptions.directory.DirectoryNotFoundException;
import ar.edu.itba.paw.models.search.Searchable;
import ar.edu.itba.paw.models.user.User;
import ar.edu.itba.paw.services.*;

import static ar.edu.itba.paw.webapp.controller.ControllerUtils.*;

import ar.edu.itba.paw.webapp.forms.admin.DeleteWithReasonForm;
import ar.edu.itba.paw.webapp.forms.directory.CreateDirectoryForm;
import ar.edu.itba.paw.webapp.forms.directory.EditDirectoryForm;
import ar.edu.itba.paw.webapp.forms.note.CreateNoteForm;
import ar.edu.itba.paw.webapp.forms.note.EditNoteForm;
import ar.edu.itba.paw.webapp.forms.search.NavigationForm;
import ar.edu.itba.paw.webapp.validation.ValidUuid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import javax.validation.Valid;
import javax.xml.ws.http.HTTPException;
import java.util.Arrays;
import java.util.UUID;

@Validated
@Controller
@RequestMapping("/directory")
public class DirectoryController {
    private final DirectoryService directoryService;
    private final NoteService noteService;
    private final SearchService searchService;
    private final SecurityService securityService;
    private final UserService userService;

    private	static	final Logger LOGGER	= LoggerFactory.getLogger(DirectoryController.class);

    @Autowired
    public DirectoryController(DirectoryService directoryService, NoteService noteService, SearchService searchService, SecurityService securityService, UserService userService) {
        this.directoryService = directoryService;
        this.noteService = noteService;
        this.searchService = searchService;
        this.securityService = securityService;
        this.userService = userService;
    }

    @RequestMapping(value = "/{directoryId}" ,method = RequestMethod.GET)
    public ModelAndView getDirectory(@PathVariable("directoryId") @ValidUuid UUID directoryId,
                                     @Valid @ModelAttribute("navigationForm") NavigationForm navigationForm,
                                     final BindingResult result, final ModelMap model) {

        if (result.hasErrors())
            throw new HTTPException(400);

        ModelAndView mav = new ModelAndView("directory");

        loadFormErrors(mav, model);

        mav.addObject("editNoteId", model.get(EDIT_NOTE_ID));
        mav.addObject("editDirectoryId", model.get(EDIT_DIRECTORY_ID));

        mav.addObject("deleteNoteIds",  toSafeJson(model.get(DELETE_NOTE_IDS)));
        mav.addObject("deleteDirectoryIds", toSafeJson(model.get(DELETE_DIRECTORY_IDS)));
        loadToastFlashAttributes(mav, model);

        userService.findById(navigationForm.getUserId()).ifPresent(u -> mav.addObject("filterUser", u));

        Directory directory = directoryService.getDirectoryById(directoryId).orElseThrow(DirectoryNotFoundException::new);

        Page<Searchable> pageResult = searchService.getNavigationResults(
                directoryId,
                navigationForm.getUserId(),
                navigationForm.getNormalizedCategory(),
                navigationForm.getWord(),
                navigationForm.getSortBy(),
                navigationForm.getAscending(),
                navigationForm.getPageNumber(),
                navigationForm.getPageSize()
        );

        mav.addObject("maxPage", pageResult.getTotalPages());
        mav.addObject("currentPage", pageResult.getCurrentPage());
        mav.addObject("results", pageResult.getContent());
        mav.addObject("directory", directory);

        mav.addObject("hierarchy", directoryService.getDirectoryPath(directoryId));

        return mav;
    }

    @RequestMapping(value = "/{directoryId}", method = RequestMethod.POST, params = "createDirectory")
    public ModelAndView addDirectory(@PathVariable("directoryId") @ValidUuid UUID directoryId,
                                     @Valid @ModelAttribute final CreateDirectoryForm createDirectoryForm,
                                     final BindingResult result,
                                     final RedirectAttributes redirectAttributes)
    {
        if(result.hasErrors()) {
            redirectAttributes.addFlashAttribute(CREATE_DIRECTORY_FORM_BINDING, result);
            return new ModelAndView("redirect:/directory/" + directoryId);
        }

        UUID childId = directoryService.create(createDirectoryForm.getName(), directoryId, createDirectoryForm.getVisible(), createDirectoryForm.getColor());
        redirectAttributes.addFlashAttribute(DIRECTORY_CREATED, true);
        return new ModelAndView("redirect:/directory/" + directoryId);
    }

    @RequestMapping(value = "/{directoryId}", method = RequestMethod.POST, params = "createNote")
    public ModelAndView addNote(@PathVariable("directoryId") @ValidUuid UUID directoryId,
                                @Valid @ModelAttribute final CreateNoteForm createNoteForm,
                                final BindingResult result,
                                final RedirectAttributes redirectAttributes)
    {

        if(result.hasErrors()) {
            redirectAttributes.addFlashAttribute(CREATE_NOTE_FORM_BINDING, result);
            return new ModelAndView("redirect:/directory/" + directoryId);
        }

        UUID noteId = noteService.createNote(createNoteForm.getName(), directoryId, createNoteForm.getVisible(), createNoteForm.getFile(), createNoteForm.getCategory());
        return new ModelAndView("redirect:/notes/" + noteId);
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public ModelAndView deleteContent(@RequestParam(required = false, defaultValue = "") UUID[] directoryIds,
                                      @RequestParam(required = false, defaultValue = "") UUID[] noteIds,
                                      @Valid @ModelAttribute("deleteWithReasonForm") final DeleteWithReasonForm deleteWithReasonForm,
                                      final BindingResult result, final RedirectAttributes redirectAttributes) {

        final ModelAndView mav = new ModelAndView("redirect:" + deleteWithReasonForm.getRedirectUrl());

        if(result.hasErrors()){
            redirectAttributes.addFlashAttribute(DELETE_WITH_REASON_FORM_BINDING, result);
            redirectAttributes.addFlashAttribute(DELETE_NOTE_IDS, Arrays.stream(noteIds).map(UUID::toString).toArray(String[]::new));
            redirectAttributes.addFlashAttribute(DELETE_DIRECTORY_IDS, Arrays.stream(directoryIds).map(UUID::toString).toArray(String[]::new));
        }
        else {
            searchService.delete(noteIds, directoryIds, deleteWithReasonForm.getReason());
            redirectAttributes.addFlashAttribute(ITEMS_DELETED, true);
        }
        return mav;
    }

    @RequestMapping(value = "/{directoryId}", method = RequestMethod.POST)
    public ModelAndView editDirectory(@PathVariable("directoryId") @ValidUuid UUID directoryId,
                                 @Valid @ModelAttribute final EditDirectoryForm editDirectoryForm,
                                 final BindingResult result, final RedirectAttributes redirectAttributes) {

        final ModelAndView mav = new ModelAndView("redirect:" + editDirectoryForm.getRedirectUrl());
        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute(EDIT_DIRECTORY_FORM_BINDING, result);
            redirectAttributes.addFlashAttribute(EDIT_DIRECTORY_ID, directoryId);
        } else {
            directoryService.update(directoryId, editDirectoryForm.getName(), editDirectoryForm.getVisible(), editDirectoryForm.getColor());
            redirectAttributes.addFlashAttribute(DIRECTORY_EDITED, true);
        }
        return mav;
    }

    @RequestMapping(value = "/{directoryId}/addfavorite", method = RequestMethod.POST)
    public ModelAndView addFavoriteDirectory(@PathVariable("directoryId") @ValidUuid UUID directoryId,
                                          @RequestParam String redirectUrl, final RedirectAttributes redirectAttributes) {
        directoryService.addFavorite(directoryId);
        redirectAttributes.addFlashAttribute(FAVORITE_ADDED, true);
        return new ModelAndView("redirect:" + redirectUrl);
    }

    @RequestMapping(value = "/{directoryId}/removefavorite", method = RequestMethod.POST)
    public ModelAndView removeFavoriteDirectory(@PathVariable("directoryId") @ValidUuid UUID directoryId,
                                          @RequestParam String redirectUrl, final RedirectAttributes redirectAttributes) {
        directoryService.removeFavorite(directoryId);
        redirectAttributes.addFlashAttribute(FAVORITE_REMOVED, true);
        return new ModelAndView("redirect:" + redirectUrl);
    }

    @ModelAttribute("user")
    public User getCurrentUser() {
        return this.securityService.getCurrentUser().orElse(null);
    }

    private void loadToastFlashAttributes(ModelAndView mav, ModelMap model){
        mav.addObject(DIRECTORY_CREATED, model.getOrDefault(DIRECTORY_CREATED, false));
        mav.addObject(DIRECTORY_DELETED, model.getOrDefault(DIRECTORY_DELETED, false));
        mav.addObject(DIRECTORY_EDITED, model.getOrDefault(DIRECTORY_EDITED, false));
        mav.addObject(NOTE_DELETED, model.getOrDefault(NOTE_DELETED, false));
        mav.addObject(FAVORITE_ADDED, model.getOrDefault(FAVORITE_ADDED, false));
        mav.addObject(FAVORITE_REMOVED, model.getOrDefault(FAVORITE_REMOVED, false));
        mav.addObject(ITEMS_DELETED, model.getOrDefault(ITEMS_DELETED, false));

    }

    private void loadFormErrors(ModelAndView mav, ModelMap model){
        addFormOrGetWithErrors(mav, model, CREATE_NOTE_FORM_BINDING, "errorsCreateNoteForm", "createNoteForm", CreateNoteForm.class);
        addFormOrGetWithErrors(mav, model, EDIT_NOTE_FORM_BINDING, "errorsEditNoteForm", "editNoteForm", EditNoteForm.class);
        addFormOrGetWithErrors(mav, model, CREATE_DIRECTORY_FORM_BINDING, "errorsCreateDirectoryForm", "createDirectoryForm", CreateDirectoryForm.class);
        addFormOrGetWithErrors(mav, model, EDIT_DIRECTORY_FORM_BINDING, "errorsEditDirectoryForm", "editDirectoryForm", EditDirectoryForm.class);
        addFormOrGetWithErrors(mav, model, DELETE_WITH_REASON_FORM_BINDING, "errorsDeleteWithReasonForm", "deleteWithReasonForm", DeleteWithReasonForm.class);
    }
}


