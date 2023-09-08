package ar.edu.itba.apuntea.persistence;

import ar.edu.itba.apuntea.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Repository
class UserJdbcDao implements UserDao{
    // Templetiza todo el borderplate para evitar la repetición
    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    // Cómo es una interfaz no es necesaria que la cree cada vez que entro en un método
    // y es por eso que creo solamente una.
    private static final RowMapper<User> ROW_MAPPER = (rs, rowNum)  ->
            new User(
                    UUID.fromString(rs.getString("user_id")),
                    rs.getString("email")
            );

    @Autowired
    public UserJdbcDao(final DataSource ds){
        this.jdbcTemplate = new JdbcTemplate(ds);
        this.jdbcInsert = new SimpleJdbcInsert(ds)
                .withTableName("Users")
                .usingGeneratedKeyColumns("user_id");
    }

    @Override
    public User create(final String email) {
        final Map<String, Object> args = new HashMap<>();
        args.put("email", email);
        jdbcInsert.execute(args);
        return new User(email);
    }

    @Override
    public Optional<User> findById(final long id) {
        return jdbcTemplate.query("SELECT * FROM Users WHERE user_id = ?",
                new Object[]{id}, ROW_MAPPER).stream().findFirst();
    }
}