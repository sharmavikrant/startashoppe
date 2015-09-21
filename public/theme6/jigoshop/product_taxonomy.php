<?php
//php get_header('shop');
get_header();
?>
    <div class="container_12">
		<div id="content" class="grid_9"><div id= "shop">
        
        <div class="bc-wrap">
            <?php do_action('jigoshop_before_main_content', 'jigoshop_breadcrumb', 20, 0); ?>
        </div>

		<?php global $wp_query; $term = get_term_by( 'slug', get_query_var($wp_query->query_vars['taxonomy']), $wp_query->query_vars['taxonomy']); ?>

		<h1 class="category_title"><?php echo wptexturize($term->name); ?></h1>

		<?php echo wpautop(wptexturize($term->description)); ?>

		<?php get_template_part( 'loop', 'shop' ); ?>

		<?php do_action('jigoshop_pagination'); ?>

		</div></div>
<aside class="grid_3" id="sidebar">
    <div class="box-holder">
        <?php if ( ! dynamic_sidebar( 'sidebar' ) ) : ?><!-- Wigitized Header --><?php endif ?>
    </div>
</aside>
</div>          
<?php 

get_footer();
?>