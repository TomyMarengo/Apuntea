package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Page;
import ar.edu.itba.paw.models.user.Role;
import ar.edu.itba.paw.models.user.User;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collection;
import java.util.Optional;
import java.util.UUID;

public interface UserService {
    Optional<User> findById(UUID userId);

    Optional<User> findByEmail(String email);

    Optional<User> findByUsername(String username);

    void create(String email, String password, UUID careerId, Role role);

    void updateProfile(String firstName, String lastName, String username, MultipartFile multipartFile, UUID careerId);

    Optional<byte[]> getProfilePicture(UUID userId);

    void updateCurrentUserPassword(String password);

    boolean updateUserPasswordWithCode(String email, String code, String password);

    void unbanUsers();

    void unbanUser(UUID userId);

    void banUser(UUID userId, String reason);

    Page<User> getStudents(String query, String status, int pageNum);

    void follow(UUID followedId);

    void unfollow(UUID followedId);

    Collection<User> getFollows();

    boolean isFollowing(UUID followedId);
    
    void updateNotificationsEnabled(boolean notificationsEnabled);

    float getAvgScore(UUID userId);

    User getNoteOwner(UUID userId, User currentUser);
}
