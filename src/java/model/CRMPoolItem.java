package model;

import java.time.LocalDateTime;

/**
 * Lightweight view object for the CRM Pool page (merged Lead + Customer unassigned list).
 * Not a DB entity — built from a UNION query in CRMPoolDAO.
 */
public class CRMPoolItem {

    private String itemType;       // "LEAD" or "CUSTOMER"
    private int    itemId;         // lead_id or customer_id
    private String fullName;
    private String phone;
    private Integer sourceId;      // nullable FK → lead_sources
    private LocalDateTime createdAt;

    public CRMPoolItem() {}

    public CRMPoolItem(String itemType, int itemId, String fullName,
                       String phone, Integer sourceId, LocalDateTime createdAt) {
        this.itemType  = itemType;
        this.itemId    = itemId;
        this.fullName  = fullName;
        this.phone     = phone;
        this.sourceId  = sourceId;
        this.createdAt = createdAt;
    }

    public String      getItemType()  { return itemType;  }
    public int         getItemId()    { return itemId;    }
    public String      getFullName()  { return fullName;  }
    public String      getPhone()     { return phone;     }
    public Integer     getSourceId()  { return sourceId;  }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setItemType(String itemType)       { this.itemType  = itemType;  }
    public void setItemId(int itemId)              { this.itemId    = itemId;    }
    public void setFullName(String fullName)       { this.fullName  = fullName;  }
    public void setPhone(String phone)             { this.phone     = phone;     }
    public void setSourceId(Integer sourceId)      { this.sourceId  = sourceId;  }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
