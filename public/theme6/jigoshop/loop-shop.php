<?php

global $columns, $post, $per_page, $wp_query;

do_action('jigoshop_before_shop_loop');

$loop = 0;

if (!isset($columns) || !$columns) $columns = apply_filters('loop_shop_columns', 3);
if (!isset($per_page) || !$per_page) $per_page = apply_filters('loop_shop_per_page', get_option('posts_per_page'));

if ($per_page > get_option('posts_per_page')) query_posts( array_merge( $wp_query->query, array( 'posts_per_page' => $per_page ) ) );

ob_start();

if (have_posts()) : while (have_posts()) : the_post(); $_product = &new jigoshop_product( $post->ID ); $loop++;
	
	?>
	<li class="product <?php if ($loop%$columns==0) echo 'last'; if (($loop-1)%$columns==0) echo 'first'; ?>">
		
		<?php do_action('jigoshop_before_shop_loop_item'); ?>
		<div class="product-image-wrap"><a href="<?php the_permalink(); ?>" class="product-image"><?php do_action('jigoshop_before_shop_loop_item_title', $post, $_product); ?></a></div>
		
		<div class="caption">
			<div class="title"><a href="<?php the_permalink(); ?>" class="product-info"><?php the_title(); ?></a></div>
			<?php do_action('jigoshop_after_shop_loop_item', $post, $_product); ?>
			<?php do_action('jigoshop_after_shop_loop_item_title', $post, $_product); ?>
		</div>
	</li><?php 
	
	if ($loop==$per_page) break;
	
endwhile; endif;

if ($loop==0) :

	echo '<p class="info">'.__('No products found which match your selection.', 'jigoshop').'</p>'; 
	
else :
	
	$found_posts = ob_get_clean();
	
	echo '<ul class="products">' . $found_posts . '</ul><div class="clear"></div>';
	
endif;

do_action('jigoshop_after_shop_loop');

if (!function_exists('jigoshop_template_loop_add_to_cart')) {
	function jigoshop_template_loop_add_to_cart( $post, $_product ) {

		do_action('jigoshop_before_add_to_cart_button');

		// do not show "add to cart" button if product's price isn't announced
		if ( $_product->get_price() === '' AND ! ($_product->is_type(array('variable', 'grouped', 'external'))) ) return;

		if ( $_product->is_in_stock() OR $_product->is_type('external') ) :
			if ( $_product->is_type(array('variable', 'grouped')) ) :
				$output = '<a href="'.get_permalink($_product->id).'" class="button">'.__('Selsdfsdfect', 'jigoshop').'</a>';
			elseif ( $_product->is_type('external') ) :
				$output = '<a href="'.get_post_meta( $_product->id, 'external_url', true ).'" class="button">'.__('Buy product', 'jigoshop').'</a>';
			else :
				$output = '<a href="'.esc_url($_product->add_to_cart_url()).'" class="button">'.__('Add to cart', 'jigoshop').'</a>';
			endif;
		elseif ( ($_product->is_type(array('grouped')) ) ) :
			return;
		else :
			$output = '<span class="nostock">'.__('Out of Stock', 'jigoshop').'</span>';
		endif;
		echo $output;

		do_action('jigoshop_after_add_to_cart_button');

	}
}