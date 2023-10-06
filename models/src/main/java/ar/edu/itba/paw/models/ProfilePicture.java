package ar.edu.itba.paw.models;

import ar.edu.itba.paw.models.exceptions.UserNotFoundException;

import java.util.UUID;

public class ProfilePicture {
    private UUID userId;
    private byte[] picture;

    public ProfilePicture(String userId, Object picture) {
        if (userId == null) throw new UserNotFoundException();
        this.userId = UUID.fromString(userId);
        this.picture = (byte[]) picture;
    }

    public UUID getUserId() {
        return userId;
    }

    public byte[] getPicture() {
        return picture;
    }
}