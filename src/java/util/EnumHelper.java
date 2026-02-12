package util;

import java.util.*;
import java.util.stream.Collectors;

public class EnumHelper {

    /**
     * Lấy TẤT CẢ giá trị enum -> List<String>
     * Dùng cho dropdown, filter
     * VD: Active, Inactive, Locked
     */
    public static <E extends Enum<E>> List<String> getAllValues(Class<E> enumClass) {
        if (enumClass == null) {
            return Collections.emptyList();
        }

        return Arrays.stream(enumClass.getEnumConstants())
                .map(Enum::name)
                .collect(Collectors.toList());
    }

    /**
     * Validate value (KHÔNG phân biệt hoa thường)
     */
    public static <E extends Enum<E>> boolean isValidIgnoreCase(
            Class<E> enumClass, String value) {

        if (enumClass == null || value == null || value.trim().isEmpty()) {
            return false;
        }

        String normalized = value.trim();

        for (E e : enumClass.getEnumConstants()) {
            if (e.name().equalsIgnoreCase(normalized)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Parse String -> Enum (KHÔNG phân biệt hoa thường)
     * Trả về null nếu invalid
     */
    public static <E extends Enum<E>> E parseIgnoreCase(
            Class<E> enumClass, String value) {

        if (enumClass == null || value == null) {
            return null;
        }

        String normalized = value.trim();

        for (E e : enumClass.getEnumConstants()) {
            if (e.name().equalsIgnoreCase(normalized)) {
                return e;
            }
        }
        return null;
    }

    /**
     * Parse + default value
     */
    public static <E extends Enum<E>> E parseIgnoreCaseOrDefault(
            Class<E> enumClass,
            String value,
            E defaultValue) {

        E result = parseIgnoreCase(enumClass, value);
        return result != null ? result : defaultValue;
    }
}
