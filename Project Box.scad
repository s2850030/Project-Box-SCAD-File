// Project Box  Version 1.0
// Designed by Neil Rieck   21 August 2019 
// Released under the standard open source GNU licence
// No warranties or liabilities accepted as per the licence.
// Use at your own risk.


// Put all the variables for the project first
//  Chassis Inner Dimensions in mm
x = 51;                 // Width
y = 71;                // Length
z = 7;                // Height
Thick = 2;           // Box thickness
Fa= 0.3;            // Ensure Penetration Fine Adjustment

// PCB Standoff Dimensions
PCBSupportx=4;
PCBSupporty=PCBSupportx*2;

// Cutout Dimensions
PCBDepth = 2;                    // depth at which the PCB is held.
COutoffsetx = 4;                //  distance in from PCBSupportx
COutWidthx = 35;               //  Cutout width in the x plane 
COutDepthz = PCBDepth+3;      //  Cutout depth in the z plane
ReliefWidth = 5;             //  Gap in side for prying out the PCB
ReliefDepth = PCBDepth+1.5; // Enough to get a screwdriver tip below the PCB

// Sanity Check
if ((PCBSupportx+COutoffsetx+COutWidthx)>x-PCBSupportx)  { 
    echo("PCBSupportx is too big");
    }

rotate([0,180,0])   // turn it all upside down for 3D print
BuildProject();

// Build the project
module BuildProject(){
    difference(){    
        union() {
        Chassis();
        BuildPCBSupports();
        }
        Cutouts();
    }
}
// The Chassis is the frame about which all of the objects are built. 
// In this application it is a hollow box.
module Chassis() { 
     difference(){
         // outer box dimensions
         translate([0,0,0]) cube([x+Thick,y+Thick,z+Thick], center=true);
         //  cut out for the PCB Inner Dimensions
         translate([0,0,-Thick]) cube([x,y,z+Fa], center=true);   
     }
 }
// PCB Supports - the triangular standoffs in the corners
module BuildPCBSupports(){
    union () {
        PCBSupport();
        mirror([1,0,0])
        PCBSupport(); 
    }
    mirror([0,1,0])
    union () {
        PCBSupport();
        mirror([1,0,0])
        PCBSupport(); 
    }

}
module PCBSupport(){
    translate([-x/2, -y/2, 0]){
         triangle_points =[[0,0],[PCBSupportx,0],[0,PCBSupporty]];
         linear_extrude(height=z+Thick, center = true)
         polygon(triangle_points);
    }
}
//  Cutouts are all of the gaps in the chassis.
module Cutouts(){
    union(){
        PCBRebate();
        Relief();
        Cutout();
    }
}
module PCBRebate(){  //the hollow inside the top of the box to hold the PCB at the PCBDepth.
    translate([-x/2,-y/2,-(z+Thick+Fa)/2]) cube([x,y,PCBDepth+Fa], center=false);  
}
module Relief(){   // Relief Cut to pry out the PCB
    translate([-(x+Thick)/2-Fa,-ReliefWidth/2,-(z+Thick+Fa)/2]) cube([Thick+Fa*2,ReliefWidth,ReliefDepth], center=false);
}
// Cutout for the standoff
module Cutout(){
    translate([-(x+Thick)/2+(COutoffsetx+PCBSupportx) ,-(y+Thick)/2-Fa,-(z+Thick+Fa)/2]) cube([COutWidthx,Thick+Fa*2,COutDepthz], center=false);
}