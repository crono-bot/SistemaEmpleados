package helpers;
import java.util.UUID;
import java.util.Random;

public class generateData {
    public static String emailRandom() {
        return "user_" + UUID.randomUUID().toString() + "@mail.com";
    }

    private static final String PASSWORD_CHARS =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";

    private static final Random random = new Random();

    public static String passwordRandom(int length) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(PASSWORD_CHARS.length());
            sb.append(PASSWORD_CHARS.charAt(index));
        }
        return sb.toString();
    }
}
