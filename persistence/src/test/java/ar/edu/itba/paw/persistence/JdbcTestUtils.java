package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Role;
import ar.edu.itba.paw.models.VerificationCode;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import java.util.HashMap;
import java.util.UUID;

import static ar.edu.itba.paw.persistence.JdbcDaoUtils.*;

public class JdbcTestUtils {
    static UUID ITBA_ID = UUID.fromString("10000000-0000-0000-0000-000000000000");
    static UUID ING_INF = UUID.fromString("c0000000-0000-0000-0000-000000000000");
    static UUID ING_MEC = UUID.fromString("c0000000-0000-0000-0000-000000000001");
    static UUID EDA_ID = UUID.fromString("50000000-0000-0000-0000-000000000000");
    static UUID EDA_DIRECTORY_ID = UUID.fromString("d0000000-0000-0000-0000-000000000000");
    static UUID PAW_DIRECTORY_ID = UUID.fromString("d0000000-0000-0000-0000-000000000001");
    static UUID GUIAS_DIRECTORY_ID = UUID.fromString("d0000000-0000-0000-0000-000000000005");
    static UUID THEORY_DIRECTORY_ID = UUID.fromString("d0000000-0000-0000-0000-000000000007");
    static UUID MVC_DIRECTORY_ID = UUID.fromString("d0000000-0000-0000-0000-000000000008");
    static UUID BASURA_ID = UUID.fromString("d0000000-0000-0000-0000-000000000009");
    static UUID MVC_NOTE_ID = UUID.fromString("a0000000-0000-0000-0000-000000000002");
    static UUID GUIA1EDA_NOTE_ID = UUID.fromString("a0000000-0000-0000-0000-000000000000");
    static UUID PARCIAL_DINAMICA_FLUIDOS_NOTE_ID = UUID.fromString("a0000000-0000-0000-0000-000000000004");
    static UUID PEPE_ID = UUID.fromString("00000000-0000-0000-0000-000000000000");
    static UUID SAIDMAN_ID = UUID.fromString("00000000-0000-0000-0000-000000000003");

    static UUID MATE_ID = UUID.fromString("50000000-0000-0000-0000-000000000005");
    static UUID TVM_ID = UUID.fromString("a0000000-0000-0000-0000-000000000006");


    //inserted in test
    static UUID TMP_PARENT_DIR_ID = UUID.fromString("dF000000-0000-0000-0000-000000000000");
    static UUID TMP_NOTE_ID_1 = UUID.fromString("aF000000-0000-0000-0000-000000000001");
    static UUID TMP_NOTE_ID_2 = UUID.fromString("aF000000-0000-0000-0000-000000000002");
    static UUID TMP_NOTE_ID_3 = UUID.fromString("aF000000-0000-0000-0000-000000000003");
    static UUID TMP_NOTE_ID_4 = UUID.fromString("aF000000-0000-0000-0000-000000000004");
    
    static UUID TMP_DIR_ID_1 = UUID.fromString("dF000000-0000-0000-0000-000000000001");
    static UUID TMP_DIR_ID_2 = UUID.fromString("dF000000-0000-0000-0000-000000000002");
    static UUID TMP_DIR_ID_3 = UUID.fromString("dF000000-0000-0000-0000-000000000003");
    static UUID TMP_DIR_ID_4 = UUID.fromString("dF000000-0000-0000-0000-000000000004");
    private JdbcTestUtils() {}

    static UUID insertStudent(NamedParameterJdbcTemplate namedParameterJdbcTemplate, String email, String password, UUID careerId, String locale) {
        MapSqlParameterSource args = new MapSqlParameterSource();
        args.addValue(EMAIL, email);
        args.addValue(PASSWORD, password);
        args.addValue(CAREER_ID, careerId);
        args.addValue(LOCALE, locale);

        KeyHolder keyHolder = new GeneratedKeyHolder();
        namedParameterJdbcTemplate.update("INSERT INTO Users (email, password, career_id, locale) VALUES (:email, :password, :career_id, :locale)",
                args, keyHolder, new String[]{USER_ID});
        UUID newUserId = (UUID) keyHolder.getKeys().get(USER_ID);

        args = new MapSqlParameterSource().addValue(USER_ID, newUserId).addValue(ROLE_NAME, Role.ROLE_STUDENT.getRole());
        namedParameterJdbcTemplate.update("INSERT INTO User_Roles (user_id, role_name) VALUES (:user_id, :role_name)", args);
        return (UUID) keyHolder.getKeys().get(USER_ID);
    }


    static UUID insertCompleteStudent(NamedParameterJdbcTemplate namedParameterJdbcTemplate, String email, String password, UUID careerId, String locale,
                                      String username, String firstName, String lastName) {
        MapSqlParameterSource args = new MapSqlParameterSource();
        args.addValue(EMAIL, email);
        args.addValue(PASSWORD, password);
        args.addValue(CAREER_ID, careerId);
        args.addValue(LOCALE, locale);
        args.addValue(USERNAME, username);
        args.addValue(FIRST_NAME, firstName);
        args.addValue(LAST_NAME, lastName);

        KeyHolder keyHolder = new GeneratedKeyHolder();
        namedParameterJdbcTemplate.update("INSERT INTO Users (email, password, career_id, locale, username, first_name, last_name) VALUES (:email, :password, :career_id, :locale, :username, :first_name, :last_name)",
                args, keyHolder, new String[]{USER_ID});
        UUID newUserId = (UUID) keyHolder.getKeys().get(USER_ID);

        args = new MapSqlParameterSource().addValue(USER_ID, newUserId).addValue(ROLE_NAME, Role.ROLE_STUDENT.getRole());
        namedParameterJdbcTemplate.update("INSERT INTO User_Roles (user_id, role_name) VALUES (:user_id, :role_name)", args);
        return (UUID) keyHolder.getKeys().get(USER_ID);
    }

    static UUID insertDirectory(NamedParameterJdbcTemplate namedParameterJdbcTemplate, String directoryName, UUID userId, UUID parentId) {
        MapSqlParameterSource args = new MapSqlParameterSource();
        args.addValue(DIRECTORY_NAME, directoryName);
        args.addValue(USER_ID, userId);
        args.addValue(PARENT_ID, parentId);

        KeyHolder keyHolder = new GeneratedKeyHolder();
        namedParameterJdbcTemplate.update("INSERT INTO Directories (directory_name, user_id, parent_id) VALUES (:directory_name, :user_id, :parent_id)",
                args, keyHolder, new String[]{DIRECTORY_ID});
        return (UUID) keyHolder.getKeys().get(DIRECTORY_ID);
    }

    static void insertReview(NamedParameterJdbcTemplate namedParameterJdbcTemplate, UUID noteId, UUID userId, int score, String content) {
        MapSqlParameterSource args = new MapSqlParameterSource();
        args.addValue(NOTE_ID, noteId);
        args.addValue(USER_ID, userId);
        args.addValue(SCORE, score);
        args.addValue(CONTENT, content);

        namedParameterJdbcTemplate.update("INSERT INTO Reviews (note_id, user_id, score, content) VALUES (:note_id, :user_id, :score, :content)",
                args);
    }

    static void insertFavorite(SimpleJdbcInsert jdbcFavoriteInsert, UUID directoryId, UUID userId) {
        jdbcFavoriteInsert.execute(new HashMap<String, Object>(){{
            put(DIRECTORY_ID, directoryId);
            put(USER_ID, userId);
        }});
    }

    static void insertVerificationCode(NamedParameterJdbcTemplate namedParameterJdbcTemplate, VerificationCode verificationCode) {
        namedParameterJdbcTemplate.update(
                "INSERT INTO Verification_Codes(user_id, code, expires_at) values(" +
                        "(SELECT user_id FROM Users WHERE email = :email), " +
                        ":code, :expires_at)",
                new MapSqlParameterSource()
                        .addValue("email", verificationCode.getEmail())
                        .addValue("code", verificationCode.getCode())
                        .addValue("expires_at", verificationCode.getExpirationDate()));
    }
}
