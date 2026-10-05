package vn.iotstar.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "order_details")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OrderDetail implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long orderDetailId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "orderId", nullable = false)
    private Order order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "videoId", nullable = false)
    private Video video;

    @Column(nullable = false)
    private int quantity;

    @Column(nullable = false, precision = 18, scale = 2)
    private BigDecimal unitPrice;

    public BigDecimal getSubTotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}