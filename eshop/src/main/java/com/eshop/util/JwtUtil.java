package com.eshop.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class JwtUtil {
    private static final String SECRET = "eshop_secret_2026";
    private static final long EXPIRE = 86400000L;

    public static String createToken(int userId, String userName) {
        long now = System.currentTimeMillis();
        String header = b64("{\"alg\":\"HS256\",\"typ\":\"JWT\"}");
        String payload = b64("{\"userId\":" + userId + ",\"userName\":\"" + userName + "\",\"exp\":" + (now + EXPIRE) + "}");
        String signature = sign(header + "." + payload);
        return header + "." + payload + "." + signature;
    }

    public static boolean verify(String token) {
        try {
            String[] parts = token.split("\\.");
            if (parts.length != 3) return false;
            if (!sign(parts[0] + "." + parts[1]).equals(parts[2])) return false;
            String json = new String(Base64.getUrlDecoder().decode(parts[1]));
            return Long.parseLong(extract(json, "exp")) > System.currentTimeMillis();
        } catch (Exception e) { return false; }
    }

    public static int getUserId(String token) {
        try {
            String json = new String(Base64.getUrlDecoder().decode(token.split("\\.")[1]));
            return Integer.parseInt(extract(json, "userId"));
        } catch (Exception e) { return 0; }
    }

    public static String getUserName(String token) {
        try {
            String json = new String(Base64.getUrlDecoder().decode(token.split("\\.")[1]));
            return extract(json, "userName");
        } catch (Exception e) { return null; }
    }

    private static String extract(String json, String key) {
        int start = json.indexOf("\"" + key + "\":");
        if (start < 0) return "";
        start += key.length() + 3;
        if (json.charAt(start) == '"') {
            start++;
            int end = json.indexOf('"', start);
            return json.substring(start, end);
        } else {
            int end = json.indexOf(',', start);
            if (end < 0) end = json.indexOf('}', start);
            return json.substring(start, end);
        }
    }

    private static String b64(String s) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(s.getBytes());
    }

    private static String sign(String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(SECRET.getBytes(), "HmacSHA256"));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(mac.doFinal(data.getBytes()));
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
