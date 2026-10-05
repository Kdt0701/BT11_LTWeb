package vn.iotstar.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "orders")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long orderId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "username", nullable = false)
    private User user;

    @Column(nullable = false, length = 30)
    private String status;

    @Column(nullable = false, length = 30)
    private String paymentMethod = "COD";

    @Column(nullable = false, precision = 18, scale = 2)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Column(nullable = false, length = 255)
    private String shippingAddress;

    @Column(nullable = false, length = 100)
    private String receiverName;

    @Column(nullable = false, length = 20)
    private String receiverPhone;

    @Column(nullable = false)
    private LocalDateTime orderDate = LocalDateTime.now();

    @Column
    private LocalDateTime deliveredAt;

    @Column(length = 1000)
    private String returnReason;

    @Column(length = 20)
    private String returnStatus = "NONE";

    @Column
    private LocalDateTime returnRequestedAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<OrderDetail> details = new ArrayList<>();
}