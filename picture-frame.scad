picture_height = 144;
picture_width = 188;

mould_width = 18;
mould_thickness = 2;

inset_width = 7;
inset_depth = 5;

peg_diam = 6;
peg_depth = 6;
peg_foot_thickness = 2;
peg_foot_width = 5.55;
peg_foot_length = 13.5;
peg_well_wall_thickness = 2;
peg_wall_thickness = 1.5;
peg_wall_crack = 1.5;

$fs=0.1;

module moulding() {
  mirror([0,1])
  difference() {
    import("moulding.svg");
    offset(delta=-mould_thickness) import("moulding.svg");
    square([inset_depth, mould_width-mould_thickness]);
  }
}

module peg_well() {
    intersection() {
      rotate([0,-90, 0]) linear_extrude(peg_diam*2, center=true)
        mirror([0,1]) import("moulding.svg");
      translate([0,-(mould_width + inset_width)/2,peg_foot_thickness]) difference() {
        cylinder(h=mould_width, d=peg_diam + 2*peg_well_wall_thickness);
        cylinder(h=mould_width*2, d=peg_diam, center=true);
      }
    }
}

module peg() {
  union () {
    hull () {
      cylinder(h=peg_foot_thickness,d=peg_foot_width);
      translate([0,peg_foot_length-peg_foot_width,0])
        cylinder(h=peg_foot_thickness,d=peg_foot_width);
    }
    difference() {
      cylinder(d=peg_diam,h=peg_depth);
      cylinder(d=peg_diam-2*peg_wall_thickness,h=peg_depth*3,center=true);
      rotate([0,0,45]) translate([0,peg_diam/2,0])
      cube([peg_wall_crack,peg_diam,peg_depth*3],center=true);
    }
  }
}

module edge(length) {
  union() {
    intersection() {
      rotate([0,-90, 0]) linear_extrude(length, center=true) moulding();
      linear_extrude(mould_width) translate([0, -mould_width])
        polygon([[-length/2,0], [length/2,0], [0, length/2]]);
    }
    if (length > 200) {
      translate([-50,0,0]) peg_well(); 
      translate([50,0,0]) peg_well(); 
    } else {
      peg_well();
    }
  }
}

module frame() {
  frame_width = picture_width + 2*(mould_width - inset_width);
  frame_height = picture_height + 2*(mould_width - inset_width);
  top_edge = picture_height/2-inset_width;
  right_edge = picture_width/2-inset_width;
  translate ([0,top_edge,0]) rotate([0,0,180]) edge(frame_width);
  translate ([right_edge,0,0]) rotate([0,0,90]) edge(frame_height);
  translate ([0,-top_edge,0]) rotate([0,0,0]) edge(frame_width);
  translate ([-right_edge,0,0]) rotate([0,0,-90]) edge(frame_height);
}
//frame();
peg();
