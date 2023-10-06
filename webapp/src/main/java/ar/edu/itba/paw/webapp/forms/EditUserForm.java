package ar.edu.itba.paw.webapp.forms;

import ar.edu.itba.paw.webapp.validation.MaxFileSize;
import ar.edu.itba.paw.webapp.validation.UnusedUsername;
import ar.edu.itba.paw.webapp.validation.ValidFileName;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class EditUserForm {

    @Pattern(regexp = "([a-zA-Z]+[ ]?)*")
    @Size(max = 20)
    private String firstName;

    @Pattern(regexp = "([a-zA-Z]+[ ]?)*")
    @Size(max = 20)
    private String lastName;

    @UnusedUsername
    @Size(max = 30)
    @Pattern(regexp = "[a-zA-Z0-9]*")
    //TODO add more restrictions
    private String username;

    @ValidFileName(allowedExtensions = {".jpeg", ".png", ".jpg"})
    @MaxFileSize(megabytes = 500, allowEmptyFiles = true)
    private MultipartFile profilePicture;

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }


    public String getUsername() {
        return username;
    }

    public MultipartFile getProfilePicture() {
        return profilePicture;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setProfilePicture(MultipartFile profilePicture) {
        this.profilePicture = profilePicture;
    }
}