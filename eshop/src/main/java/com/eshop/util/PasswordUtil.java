package com.eshop.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtil {
    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public static String encode(String raw) {
        return encoder.encode(raw);
    }

    public static boolean matches(String raw, String encoded) {
        if (encoded == null) return false;
        // BCrypt hashes start with $2a$, $2b$ or $2y$
        if (encoded.startsWith("$2")) {
            return encoder.matches(raw, encoded);
        }
        // Plain text fallback (for legacy passwords)
        return raw.equals(encoded);
    }
}
