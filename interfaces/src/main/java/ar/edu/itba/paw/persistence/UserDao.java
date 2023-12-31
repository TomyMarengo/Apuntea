package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.institutional.Career;
import ar.edu.itba.paw.models.user.Image;
import ar.edu.itba.paw.models.user.Role;
import ar.edu.itba.paw.models.user.User;
import ar.edu.itba.paw.models.user.UserStatus;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserDao {
    void create(String email, String password, Career career, String lang, Collection<Role> role);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    Optional<User> findById(UUID userId);
    void updateProfilePicture(User user, Image img);
    void follow(User follower, UUID followedId);
    void unfollow(User follower, UUID followedId);
    int unbanUsers();
    boolean banUser(User user, User admin, LocalDateTime endDate, String reason);
    boolean unbanUser(User user);
    List<User> getStudents(String query, UserStatus status, int pageNum, int pageSize);
    int getStudentsQuantity(String query, UserStatus status);
    float getAvgScore(UUID userId);
}
