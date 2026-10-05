package vn.iotstar.entity;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.*;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "favorites")
public class Favorite implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "favoriteId")
    private int favoriteId;

    @Column(name = "likeDate")
    @Temporal(TemporalType.DATE)
    private Date likedDate;

    @ManyToOne
    @JoinColumn(name = "username") 
    private User user;

    @ManyToOne
    @JoinColumn(name = "videoId")
    private Video video;
}