<?php 

function tm_include_jigoscript() {
    if (!is_admin()) {
        wp_enqueue_script('jigoscript', get_bloginfo('template_url').'/jigoshop/jigoscript.js', array('jquery'), '1.0', true);
    }
}
add_action('wp_enqueue_scripts', 'tm_include_jigoscript', 20);

//Register sidebars


function jigoshop_widgets_init() {
    // Cart Holder
    register_sidebar(array(
        'name'                  => 'Cart Holder',
        'id'                        => 'cart-holder',
        'description'   => __( 'Contains shopping cart.'),
        'before_widget' => '<div id="%2$s">',
        'after_widget' => '</div></div>',
        'before_title' => '<h3>',
        'after_title' => '</h3><div class="widget-holder">',
    ));
}
add_action( 'widgets_init', 'jigoshop_widgets_init' );

// Show product images


add_action( 'tm_single_product_images', 'tm_show_product_images'    , 10);

function tm_show_product_images() {

    global $_product, $post;
    $jigoshop_options = Jigoshop_Base::get_options();

?>
    <div class="images">
        <?php
            $args = array(
                'post_type' => 'attachment', 
                'post_mime_type' => 'image', 
                'numberposts' => -1, 
                'post_status' => null, 
                'post_parent' => $post->ID, 
                'orderby' => 'menu_order', 
                'order' => 'asc'
            );
            $attachments = get_posts( $args );
            if ( $attachments ) { 
        ?>
        <div id="holder" class="img-holder">
            <?php
                    $large_img_w = $jigoshop_options->get_option('jigoshop_shop_large_w');
                    $large_img_h = $jigoshop_options->get_option('jigoshop_shop_large_h');
                    $th_url = wp_get_attachment_url( get_post_thumbnail_id($post->ID) );
                    $image = aq_resize( $th_url, $large_img_w, $large_img_h, true );
            ?>
            <?php if ( has_post_thumbnail() ) { ?>
            <a id="prettyLink" href="<?php echo $th_url; ?>" rel="prettyPhoto" class="item1" title="<?php echo get_the_title(); ?>">
                <img alt="<?php the_title(); ?>" src="<?php echo $image; ?>">
            </a>
            <?php } else {
                $iter = 0;
                $iter_alt = 0;
                foreach ( $attachments as $attachment ) {
                    $iter_alt ++;
                    $cur_url = wp_get_attachment_url( $attachment->ID, false );
                    $image = aq_resize( $cur_url, $large_img_w, $large_img_h, true );
                    if ( ! $image || $cur_url == get_post_meta($post->ID, 'file_path', true) ) {
                        $chek = 1;
                        continue;
                    }
                    if ($iter == 0) {
            ?>
                <a id="prettyLink" href="<?php echo $cur_url; ?>" rel="prettyPhoto" class="item1" title="<?php echo get_the_title(); ?>">
                    <img alt="<?php the_title(); ?>" src="<?php echo $image; ?>">
                </a>
            <?php
                    }
                    $iter ++;
                }
            } 
            if ( (0 == $check) && (1 == $iter_alt)) {
            ?>
            <img src="<?php bloginfo( 'template_url' ); ?>/images/placeholder.png" alt="<?php the_title(); ?>">
            <?php
            }
        ?>
        </div>
        <div class="sub-pager">
            <?php
                
                    if ( has_post_thumbnail() ) {
                        $th_url = wp_get_attachment_url( get_post_thumbnail_id($post->ID) );
                        $image_lr = aq_resize( $th_url, $large_img_w, $large_img_h, true );
                        $image = aq_resize( $th_url, 90, 90, true );
                        echo "<a href='".$image_lr."' data-href='".$th_url."' class='cur'>";
                            echo "<img alt='".get_the_title()."' src='".$image."'>";
                        echo "</a>";
                    }
                   
                    foreach ( $attachments as $attachment ) {
                        $cur_url = wp_get_attachment_url( $attachment->ID, false );
                        if ($cur_url != $th_url) {
                            $image = aq_resize( $cur_url, 90, 90, true);
                            if ( ! $image || $cur_url == get_post_meta($post->ID, 'file_path', true) )
                                continue;
                            $image_lr = aq_resize( $cur_url, $large_img_w, $large_img_h, true );
                            
                            echo "<a href='".$image_lr."' data-href='".$cur_url."'>";
                                echo "<img alt='".get_the_title()."' src='".$image."'>";
                            echo "</a>";
                        }
                    }
            ?>
        </div>
    <?php } else { ?>
        <div id="holder" class="img-holder">
            <img src="<?php bloginfo( 'template_url' ); ?>/images/placeholder.png" alt="<?php the_title(); ?>">
        </div>
    <?php } ?>
    </div>
<?php
}

if (!function_exists('jigoshop_output_content_wrapper')) {
    function jigoshop_output_content_wrapper() {
        if(  get_option('template') === 'twentyeleven' ) echo '<section id="primary"><div id="content" role="main">';
        else echo '';  /* twenty-ten */
    }
}
include_once (TEMPLATEPATH . '/jigoshop/widgets/my-recent_products.php');
include_once (TEMPLATEPATH . '/jigoshop/widgets/my-featured_products.php');
include_once (TEMPLATEPATH . '/jigoshop/widgets/recent_products.php');
include_once (TEMPLATEPATH . '/jigoshop/widgets/recent_reviews.php');
add_action("widgets_init", "load_jigo_widgets");
function load_jigo_widgets() {

    register_widget("MY_RecentProducts");
    register_widget("MY_FeaturedProducts");
    register_widget("My_Widget_Recent_Products");
    register_widget("my_Widget_Recent_Reviews");
}
if (!function_exists('jigoshop_product_attributes_tab')) {
    function jigoshop_product_attributes_tab( $current_tab ) {

        global $_product;
        if( ( $_product->has_attributes() || $_product->has_dimensions() || $_product->has_weight() ) ):
        ?>
        <li <?php if ($current_tab=='#tab-attributes') echo 'class="active"'; ?>><a href="#tab-attributes"><?php _e('Info', 'jigoshop'); ?></a></li><?php endif;

    }
}
if (!function_exists('jigoshop_pagination')) {
    function jigoshop_pagination() {
        global $wp_query;

        if (  $wp_query->max_num_pages > 1 ) :
            get_template_part('includes/post-formats/post-nav');
        endif;
    }
}
?>