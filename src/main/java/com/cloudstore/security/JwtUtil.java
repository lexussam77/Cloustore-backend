package com.cloudstore.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.Map;


@Component
public class JwtUtil {
    private final String jwtSecret;
    private final long jwtExpirationMs;

    public JwtUtil(
        @Value("${jwt.secret}") String jwtSecret,
        @Value("${jwt.expiration}") long jwtExpirationMs
    ) {
        // Provide a fallback default secret if injected secret is invalid
        String defaultSecret = "QwErTyUiOpAsDfGhJkLzXcVbNm1234567890QWERTYUIOPASDFGHJKLZXCVBNM";
        if (jwtSecret == null || jwtSecret.length() < 32) {
            System.err.println("Warning: JWT secret is invalid or missing. Using default secret.");
            jwtSecret = defaultSecret;
        }
        this.jwtSecret = jwtSecret;
        this.jwtExpirationMs = jwtExpirationMs;
    }

    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    public String generateToken(Long userId, String email) {
        return Jwts.builder()
                .setSubject(email)
                .claim("userId", userId)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public Claims getClaimsFromToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean validateToken(String token) {
        try {
            getClaimsFromToken(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    public String getEmailFromToken(String token) {
        return getClaimsFromToken(token).getSubject();
    }

    public Long getUserIdFromToken(String token) {
        Object userId = getClaimsFromToken(token).get("userId");
        return userId != null ? Long.valueOf(userId.toString()) : null;
    }
} 