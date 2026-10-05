package vn.iotstar.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Builder
@Table(name = "videos")
public class Video implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "videoid", length = 50)
    private String videoId; // VideoID dạng chuỗi

    @Column(name = "title", columnDefinition = "nvarchar(255)")
    private String title;

    @Column(name = "poster", columnDefinition = "nvarchar(500)")
    private String poster;

    @Column(name = "views")
    private int views;

    @Column(name = "price", precision = 18, scale = 2, nullable = false)
    private BigDecimal price = BigDecimal.ZERO;

    @Column(name = "stock", nullable = false)
    private int stock = 0;

    @Column(name = "description", columnDefinition = "nvarchar(MAX)")
    private String description;

    @Column(name = "active")
    private boolean active;

    @ManyToOne
    @JoinColumn(name = "CategoryId")
    private Category category;

    // Quan hệ 1-N: Video có nhiều lượt Like
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL)
    private List<Favorite> favorites;

    // Quan hệ 1-N: Video có nhiều lượt Share
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL)
    private List<Share> shares;

}
