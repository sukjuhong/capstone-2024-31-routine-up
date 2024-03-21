package km.cd.backend.auth;

import km.cd.backend.jwt.JwtTokenProvider;
import km.cd.backend.jwt.JwtTokenResponse;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import km.cd.backend.user.dto.UserLogin;
import km.cd.backend.user.dto.UserRegister;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    private User emailExists(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    @Transactional
    public void register(final UserRegister userRequest) {
        if (emailExists(userRequest.getEmail()) != null) {
            throw new RuntimeException();
        }

        String encodedPassword = passwordEncoder.encode(userRequest.getPassword());

        User user = User.builder()
                .email(userRequest.getEmail())
                .password(encodedPassword)
                .name(userRequest.getName())
                .build();
        userRepository.save(user);
    }

    public JwtTokenResponse login(UserLogin userLogin) {
        String email = userLogin.getEmail();

        User user = emailExists(email);
        if (user == null) {
            throw new RuntimeException();
        }

        if (!passwordEncoder.matches(userLogin.getPassword(), user.getPassword())) {
            throw new RuntimeException();
        }

        String accessToken = jwtTokenProvider.generateAccessToken(
                user.getEmail(),
                user.getName(),
                Collections.singleton(new SimpleGrantedAuthority(user.getRole()))
        );

        return JwtTokenResponse.builder()
                .accessToken(accessToken)
                .build();
    }

}
