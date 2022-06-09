picture_height = 144;
picture_width = 188;

mould_width = 18;

inset_width = 7;
inset_depth = 3;

retainer_peg_diam = 6;
retainer_peg_depth = 6;
retainer_peg_play = 0;

$fs=0.1;

module moulding() {
  mirror([0,1])
  difference() {
    import("moulding.svg");
    square([inset_depth, inset_width]);
  }
}

module edge(length) {
  difference() {
    intersection() {
      rotate([0,-90, 0]) linear_extrude(length, center=true) moulding();
      linear_extrude(mould_width) translate([0, -mould_width])
        polygon([[-length/2,0], [length/2,0], [0, length/2]]);
    }
    translate([0,-(mould_width + inset_width)/2])
      cylinder(h=retainer_peg_depth*2, d=retainer_peg_diam+retainer_peg_play, center=true);
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
frame();
//moulding();