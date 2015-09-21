<?php
// =============================== My Request Quote Widget ======================================
class MY_FeaturedProducts extends WP_Widget {
    /** constructor */
    function MY_FeaturedProducts() {
        parent::WP_Widget(false, $name = 'My - Featured Products');	
    }

    /** @see WP_Widget::widget */
    function widget($args, $instance) {		
        extract( $args );
        $title = apply_filters('widget_title', $instance['title']);
		$prod_count = apply_filters('prod_count', $instance['prod_count']);
        ?>

		<?php 
			$code = '[featured_products per_page="'.$prod_count.'"]';
		?>
              <?php echo $before_widget; ?>
			  			<div class="featured-products">
							<?php if($title!=""){ ?>
								
							<div class="widgetHolder">
								<h2><?php echo $title; ?></h2>
								<?php echo do_shortcode($code); ?>
							</div><!-- end 'with title' -->
							<?php } else { ?>
							<div class="widgetHolder">
								<?php echo do_shortcode($code); ?>
							</div><!-- end 'without title' -->
							<?php } ?>
						</div>
              <?php echo $after_widget; ?>
        <?php
    }

    /** @see WP_Widget::update */
    function update($new_instance, $old_instance) {				
        return $new_instance;
    }

    /** @see WP_Widget::form */
    function form($instance) {				
        $title = esc_attr($instance['title']);
				$prod_count = esc_attr($instance['prod_count']);
        ?>
       <p><label for="<?php echo $this->get_field_id('title'); ?>"><?php _e('Title:', 'kiosk'); ?> <input class="widefat" id="<?php echo $this->get_field_id('title'); ?>" name="<?php echo $this->get_field_name('title'); ?>" type="text" value="<?php echo $title; ?>" /></label></p>
			 
			 <p><label for="<?php echo $this->get_field_id('prod_count'); ?>"><?php _e('Count of Products:', 'kiosk'); ?> <input id="<?php echo $this->get_field_id('prod_count'); ?>" size="3" name="<?php echo $this->get_field_name('prod_count'); ?>" type="text" value="<?php echo $prod_count; ?>" /></label></p>
		
        <?php 
    }

} // class Request Quote Widget

?>