package ar.edu.itba.paw.webapp.config;

import ar.edu.itba.paw.webapp.auth.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.concurrent.TimeUnit;

@Configuration
@EnableWebSecurity
@ComponentScan({"ar.edu.itba.paw.webapp.auth"})
public class WebAuthConfig extends WebSecurityConfigurerAdapter {
    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    public void configure(final HttpSecurity http) throws Exception {

        http.sessionManagement()
                .invalidSessionUrl("/login")

                .and().authorizeRequests()
                    .antMatchers("/login",
                                "/register").anonymous()
                    .antMatchers("/",
                                "/search",
                                "/notes/{noteId}",
                                "/notes/{noteId}/download",
                                "/errors/**").permitAll()
                    .antMatchers("/**").authenticated()

                .and().formLogin()
                    .loginPage("/login")
                    .usernameParameter("email").passwordParameter("password")
                    .defaultSuccessUrl("/", false)

                .and().rememberMe()
                    .rememberMeParameter("rememberMe")
                    .userDetailsService(userDetailsService)
//                 .rememberMeCookieName("remember-me-cookie")
    //                 .key("") // TODO: Create a key
                    .tokenValiditySeconds((int) TimeUnit.DAYS.toSeconds(1))

                .and().logout()
                    .logoutUrl("/logout")
                    .logoutSuccessUrl("/login")

                .and().exceptionHandling()
                    .accessDeniedPage("/errors/403")

                .and().headers().frameOptions().sameOrigin()

                .and().csrf().disable();
    }

    @Override
    public void configure(final WebSecurity web) throws Exception {
        web.ignoring().antMatchers("/svg/**", "/css/**", "/js/**", "/image/**", "favicon.ico", "/errors/**");
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}