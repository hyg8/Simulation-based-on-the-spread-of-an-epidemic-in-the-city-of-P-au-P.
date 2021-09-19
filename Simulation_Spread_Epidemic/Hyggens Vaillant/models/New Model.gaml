/***
* Name: NewModel
* Author: Hyggens Vaillant
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model NewModel

/* Insert your model definition here */

global {
	
	/** Insert the global definitions, variables and actions here */
	file street_shape_file <- file ("../includes/street.shp");
	file shape_file_Hopital <- file ("../includes/Hopital.shp");
	file shape_file_Ecole <- file ("../includes/Ecole.shp");
	file shape_file_Park <- file ("../includes/Park.shp");
	file shape_file_Travail <- file ("../includes/Travail.shp");
	file shape_file_Maison <- file ("../includes/Maison.shp");
	graph the_graph;
	/** Insert the global definitions, variables and actions here */
	
	geometry shape <- envelope(street_shape_file);
	
	init{
		create street from: street_shape_file;
		the_graph <- as_edge_graph(street);
		create Hopital from: shape_file_Hopital;
		create Ecole from: shape_file_Ecole;
		create Park from: shape_file_Park;
		create Travail from: shape_file_Travail;
		create Maison from: shape_file_Maison;
		create Habitants number:2000{
			maison<-one_of(Maison);
			location<-any_location_in(one_of(street));
			if flip(0.2){
				malade<-true;
			}
		}
		}
		reflex fin{
			if(length(list(Habitants where each.malade))=0){
			do pause;
		}
		}
		
		
}


species Ecole{
	rgb color <- #pink;
	aspect base{
		draw shape color: color ;
	}
	}

species Park{
	rgb color <- #orange;
	aspect base{
		draw shape color: color;
	}
}

species street{
	rgb color <- #purple;
	aspect base{
		draw shape color: color;
		
		
	}
}

species Hopital{
	rgb color <- #violet;
	aspect base{
		draw shape color: color;
		
		
	}
}
species Travail{
	rgb color <- #brown;
	aspect base{
		draw shape color: color;		
	}
}

species Maison{
	rgb color <- #blue;
	aspect base{
		draw shape color: color;
	}
		
}

species Habitants skills:[moving]{
	bool malade <- false;
	Maison maison <- nil;
	bool alhopital<-false;
	int temps_infection<-0;
	rgb color <-#green;
	
	point destination <- nil;
	
	reflex circuler when:!malade{
		if destination = nil{
			if(flip(0.5)){
			destination <-maison;
			}else{
				destination <-any_location_in(one_of(Travail+Park+Ecole));
			}
		}
		if(destination distance_to self < 4){
			destination <- nil;
		}else{
			 
		do wander;
		do goto target: destination speed:0.001 on:the_graph;
		}
		
	}

	
	
		reflex infected when:malade and !alhopital{
			temps_infection<-temps_infection+1;
		destination <-Hopital with_min_of(each  distance_to self);
		
		if(destination distance_to self < 4){
			alhopital <-true;
		}else{
		do goto target: destination speed:0.001 on:the_graph;
		}
		
		
		
		ask Habitants at_distance(20){
			self.malade<-true;
		}
		
		if(temps_infection>100){
			do die;
		}
		
		
	}
	reflex soin_retablir when:malade and alhopital{
		temps_infection<-temps_infection-1;
		if(temps_infection<0){
			write "soigne";
			self.malade<-false;
			temps_infection<-0;
			
		}
	}
	
	
	
	aspect base{
		color<-malade?#red:#green;
		//color<-alhopital?#orange:color;
		draw circle(5) color:color;
	}
}
experiment model0 type: gui {
	/** Insert here the definition of the input and output of the model */
	output {
		
		display map type:opengl{
		species street aspect: base ;
		species Habitants aspect: base;
		species Hopital aspect: base;
	    species Ecole aspect: base;
	    species Park aspect: base;
	    species Travail aspect: base;
	    species Maison aspect: base;
	    }
		
	}
}
