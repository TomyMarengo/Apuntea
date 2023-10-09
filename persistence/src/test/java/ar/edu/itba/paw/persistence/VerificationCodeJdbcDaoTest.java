package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.VerificationCode;
import ar.edu.itba.paw.models.exceptions.UserNotFoundException;
import ar.edu.itba.paw.persistence.config.TestConfig;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.time.LocalDateTime;
import java.util.UUID;

import static ar.edu.itba.paw.persistence.JdbcDaoTestUtils.*;
import static junit.framework.TestCase.assertEquals;
import static org.junit.Assert.*;

import org.springframework.test.jdbc.JdbcTestUtils;

@Transactional
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = TestConfig.class)
@Rollback
public class VerificationCodeJdbcDaoTest {

    @Autowired
    private DataSource ds;

    @Autowired
    private VerificationCodeDao verificationCodeDao;

    private JdbcTemplate jdbcTemplate;
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;


    @Before
    public void setUp() {
        jdbcTemplate = new JdbcTemplate(ds);
        namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(ds);
    }

    @Test
    public void testSaveVerificationCode() {
        String email = "no@itba.edu.ar";
        UUID studentId = insertStudent(namedParameterJdbcTemplate, email, "", ING_INF, "es");
        VerificationCode verificationCode = new VerificationCode("123456", email, LocalDateTime.now().plusMinutes(10));
        verificationCodeDao.saveVerificationCode(verificationCode);
        assertEquals(1, JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes", "user_id = '" + studentId + "' AND code = '123456' AND expires_at > NOW()"));
    }

    @Test
    public void testSaveVerificationCodeInvalidEmail() {
        VerificationCode verificationCode = new VerificationCode("123456", "queenelizabeth@itba.edu.uk", LocalDateTime.now().plusMinutes(10));
        assertThrows(UserNotFoundException.class, () -> verificationCodeDao.saveVerificationCode(verificationCode));
        assertEquals(0, JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes",  "code = '123456' AND expires_at > NOW()"));
    }

    @Test
    public void testVerifyForgotPasswordCode() {
        String email = "verification@itba.edu.ar";
        insertStudent(namedParameterJdbcTemplate, email, "", ING_INF, "es");
        VerificationCode code = new VerificationCode("123456", email, LocalDateTime.now().plusMinutes(10));
        insertVerificationCode(namedParameterJdbcTemplate, code);
        assertTrue(verificationCodeDao.verifyForgotPasswordCode(code.getEmail(), code.getCode()));
    }

    @Test
    public void testVerifyForgotPasswordCodeInvalidCode() {
        String email = "verification@itba.edu.ar";
        insertStudent(namedParameterJdbcTemplate, email, "", ING_INF, "es");
        VerificationCode code = new VerificationCode("123456", "verification@itba.edu.ar", LocalDateTime.now().plusMinutes(10));
        insertVerificationCode(namedParameterJdbcTemplate, code);
        assertFalse(verificationCodeDao.verifyForgotPasswordCode(code.getEmail(), "123457"));
    }

    @Test
    public void testVerifyForgotPasswordCodeInvalidEmail() {
        assertFalse(verificationCodeDao.verifyForgotPasswordCode("verification@itba.edu.ar", "123457"));
    }

    @Test
    public void testVerifyForgotPasswordExpired() {
        String email = "verification@itba.edu.ar";
        insertStudent(namedParameterJdbcTemplate, email, "", ING_INF, "es");
        VerificationCode code = new VerificationCode("123456", "verification@itba.edu.ar", LocalDateTime.now().minusMinutes(10));
        insertVerificationCode(namedParameterJdbcTemplate, code);
        assertFalse(verificationCodeDao.verifyForgotPasswordCode(code.getEmail(), "123456"));
    }

    @Test
    public void testDeleteVerificationCodes() {
        String email = "verification@itba.edu.ar";
        insertStudent(namedParameterJdbcTemplate, email, "", ING_INF, "es");
        for (int i = 0; i < 10; i++) {
            VerificationCode code = new VerificationCode("12345" + i, email, LocalDateTime.now().plusMinutes(10));
            insertVerificationCode(namedParameterJdbcTemplate, code);
        }
        int oldQty = JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes", "user_id = (SELECT user_id FROM users WHERE email = '" + email + "')");
        boolean success = verificationCodeDao.deleteVerificationCodes(email);
        assertTrue(success);
        assertEquals(10, oldQty);
        assertEquals(0, JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes", "user_id = (SELECT user_id FROM users WHERE email = '" + email + "')"));
    }

    @Test
    public void testRemoveExpiredCodes() {
        String email1 = "verification@itba.edu.ar";
        String email2 = "verification2@itba.edu.ar";
        insertStudent(namedParameterJdbcTemplate, email1, "", ING_INF, "es");
        insertStudent(namedParameterJdbcTemplate, email2, "", ING_MEC, "es");
        for (int i = 0; i < 10; i++) {
            VerificationCode code = new VerificationCode("12345" + i, i % 2 == 0? email1 : email2, LocalDateTime.now().minusMinutes(10));
            insertVerificationCode(namedParameterJdbcTemplate, code);
        }
        int oldQty1 = JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes", "user_id = (SELECT user_id FROM users WHERE email = '" + email1 + "')");
        int oldQty2 = JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes", "user_id = (SELECT user_id FROM users WHERE email = '" + email2 + "')");
        int oldQty = JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes", "expires_at < NOW()");
        verificationCodeDao.removeExpiredCodes();
        assertEquals(5, oldQty1);
        assertEquals(5, oldQty2);
        assertEquals(10, oldQty);
        assertEquals(0, JdbcTestUtils.countRowsInTableWhere(jdbcTemplate, "verification_codes", "expires_at < NOW()"));
    }
 }