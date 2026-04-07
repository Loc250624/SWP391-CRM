package util;

import java.util.List;

public class PagedResult<T> {

    private List<T> items;
    private int totalItems;
    private int page;
    private int pageSize;

    public PagedResult() {
    }

    public PagedResult(List<T> items, int totalItems, int page, int pageSize) {
        this.items = items;
        this.totalItems = totalItems;
        this.page = page;
        this.pageSize = pageSize;
    }

    public void setItems(List<T> items) {
        this.items = items;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public List<T> getItems() {
        return items;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public int getPage() {
        return page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalPages() {
        if (pageSize == 0) return 0;
        return (int) Math.ceil((double) totalItems / pageSize);
    }
}
