package ar.edu.itba.paw.webapp.forms;

import ar.edu.itba.paw.webapp.validation.RemainingLinkedCareers;
import ar.edu.itba.paw.webapp.validation.ValidUuid;

import javax.validation.constraints.NotNull;
import java.util.UUID;

@RemainingLinkedCareers
public class UnlinkSubjectForm {

    @ValidUuid
    @NotNull
    private UUID subjectId;

    public UUID getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(UUID subjectId) {
        this.subjectId = subjectId;
    }
}