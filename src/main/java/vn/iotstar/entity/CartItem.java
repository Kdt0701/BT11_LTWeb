package vn.iotstar.entity;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;
    private Video video;
    private int quantity;

    public BigDecimal getSubTotal() {
        if (video == null || video.getPrice() == null) return BigDecimal.ZERO;
        return video.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
}