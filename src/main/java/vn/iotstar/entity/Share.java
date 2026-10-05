package vn.iotstar.entity;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.*;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "shares")
public class Share implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "shareId")
    private int shareId;

    @Column(name = "emails", columnDefinition = "nvarchar(500)")
    private String emails;

    @Column(name = "shareDate")
    @Temporal(TemporalType.DATE)
    private Date sharedDate;

    @ManyToOne
    @JoinColumn(name = "username")
    private User user;

    @ManyToOne
    @JoinColumn(name = "videoId")
    private Video video;
}