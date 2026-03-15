package util;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AuthorizationUtils {

    // Roles constants
    public static final String ADMIN = "ADMIN";
    public static final String MARKETING = "MARKETING";
    public static final String MANAGER = "MANAGER";
    public static final String SALE = "SALE";
    public static final String SALES = "SALES"; // Compatibility check
    public static final String LEAD_CUSTOMER = "LEAD_CUSTOMER";
    public static final String CUSTOMER_SUCCESS = "CUSTOMERSUCCESS";

    // Permission constants
    public static final String USER_VIEW_LIST = "USER_VIEW_LIST";
    public static final String USER_CREATE = "USER_CREATE";
    public static final String USER_EDIT = "USER_EDIT";
    public static final String USER_DELETE = "USER_DELETE";
    public static final String USER_RESET_PASSWORD = "USER_RESET_PASSWORD";
    public static final String USER_ASSIGN_ROLE = "USER_ASSIGN_ROLE";
    public static final String USER_IMPORT = "USER_IMPORT";
    public static final String USER_VIEW_PROFILE = "USER_VIEW_PROFILE";
    public static final String USER_UPDATE_PROFILE = "USER_UPDATE_PROFILE";
    public static final String USER_CHANGE_PASSWORD = "USER_CHANGE_PASSWORD";
    
    public static final String ROLE_VIEW_LIST = "ROLE_VIEW_LIST";
    public static final String ROLE_CREATE = "ROLE_CREATE";
    public static final String ROLE_EDIT = "ROLE_EDIT";
    public static final String ROLE_DELETE = "ROLE_DELETE";

    private static final Map<String, List<String>> ROLE_PERMISSIONS = new HashMap<>();

    static {
        // ADMIN has all permissions
        ROLE_PERMISSIONS.put(ADMIN, Arrays.asList(
                USER_VIEW_LIST, USER_CREATE, USER_EDIT, USER_DELETE, 
                USER_RESET_PASSWORD, USER_ASSIGN_ROLE, USER_IMPORT,
                USER_VIEW_PROFILE, USER_UPDATE_PROFILE, USER_CHANGE_PASSWORD,
                ROLE_VIEW_LIST, ROLE_CREATE, ROLE_EDIT, ROLE_DELETE
        ));

        // MANAGER permissions
        ROLE_PERMISSIONS.put(MANAGER, Arrays.asList(
                USER_VIEW_LIST,
                USER_VIEW_PROFILE, USER_UPDATE_PROFILE, USER_CHANGE_PASSWORD
        ));

        // MARKETING permissions
        ROLE_PERMISSIONS.put(MARKETING, Arrays.asList(
                USER_VIEW_PROFILE, USER_UPDATE_PROFILE, USER_CHANGE_PASSWORD
        ));

        // SALE permissions
        ROLE_PERMISSIONS.put(SALE, Arrays.asList(
                USER_VIEW_PROFILE, USER_UPDATE_PROFILE, USER_CHANGE_PASSWORD
        ));
        ROLE_PERMISSIONS.put(SALES, Arrays.asList(
                USER_VIEW_PROFILE, USER_UPDATE_PROFILE, USER_CHANGE_PASSWORD
        ));

        // LEAD/CUSTOMER permissions
        ROLE_PERMISSIONS.put(LEAD_CUSTOMER, Arrays.asList(
                USER_VIEW_PROFILE, USER_UPDATE_PROFILE, USER_CHANGE_PASSWORD
        ));
        
        // CUSTOMER SUCCESS
        ROLE_PERMISSIONS.put(CUSTOMER_SUCCESS, Arrays.asList(
                USER_VIEW_PROFILE, USER_UPDATE_PROFILE, USER_CHANGE_PASSWORD
        ));
    }

    /**
     * Checks if a role has a specific permission.
     * @param roleCode The role code (e.g., "ADMIN", "SALE")
     * @param permission The permission string
     * @return true if permitted, false otherwise
     */
    public static boolean hasPermission(String roleCode, String permission) {
        if (roleCode == null) return false;
        
        String upperRole = roleCode.toUpperCase().trim();
        
        // Admin always has permission
        if (ADMIN.equals(upperRole)) return true;
        
        List<String> permissions = ROLE_PERMISSIONS.get(upperRole);
        return permissions != null && permissions.contains(permission);
    }
}
