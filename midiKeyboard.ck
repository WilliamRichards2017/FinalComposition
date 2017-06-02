/* Will Richards, collabed in logic with Charlie Martens to make .wav files
 *  MUSC 208
 *  Interactive composition
 */


//Midi event
MidiIn min;
//Midi Message
MidiMsg msg;

class cos extends Chugen
{
    
    0 => int p;
    0 => int count;
    440 => float f;
    second/samp => float SRATE;
    
    fun float tick(float in)
    {
        return Math.cos(((count++)*30)*2*pi*f/SRATE);
    }
    
    fun void freq(float frequency){
        frequency => f;
    }
    
    

}


cos synth => JCRev r => Echo e => Echo e2 => Pan2 p => dac;

synth.gain(0);

// set delays
240::ms => e.max => e.delay;
480::ms => e2.max => e2.delay;
// set gains
.6 => e.gain;
.3 => e2.gain;
.05 => r.mix;  
  //Sound that will control the midi keyboard 
int id[100];          // Array to store notes currently being played
int  counter;        // Counter to see how many notes we are currently playing

//Set head of SndBuf to end of sample
//Midi divice port
0 => int device;

min.open( device );  // opens midi device

while( true ){
    // Listens for midi event
    min => now;
    
    //Process midi data 
    while( min.recv( msg ) ){
        
        //Debug statements, uncomment ot print out device input data
       <<<msg.data1, msg.data2, msg.data3>>>;
        
        //left wheel
        if (msg.data1 == 224) {
            msg.data3/127.0 => p.pan;           
        }
        
        //right wheel and nobs
        if (msg.data1 == 176) {
            //right wheel
            if(msg.data2 == 1) {
               // msg.data3/127.0 => p.gain;
                }
                
                //Top nob 1
                if(msg.data2 == 20) {
                 //   msg.data3/127.0 => sines.gain;
                }
                
                //Top nob 2
                if(msg.data2 == 21) {
                //    msg.data3/127.0 => harmony.gain;
                }
                
                if(msg.data2 == 22) {
                 //   msg.data3/127.0 => piano.gain;
                }
                if(msg.data2 == 23) {
                 //   msg.data3/127.0 => metronome.gain;
                }


        }
        
       //Touch pad area
       else if( msg.data1 == 153) {
           //pad 1
            if(msg.data2 == 49) {
             //   0 => sines.pos;
            }
            //pad 2
            else if(msg.data2 == 41) {
             //   0 => harmony.pos;
            } 
            //pad 3
            else if(msg.data2 == 42) {
            //    0 => piano.pos;
            } 
            
            //pad 4
            else if(msg.data2 == 46) {
             //   0 => metronome.pos;
            } 

             //pad 8
            else if(msg.data2 == 39) {
             
            } 
            
        }
       
       //Check if midi key is pressed, 
       //idk why key press is inconsitently 145 or 144
       else if( msg.data1 == 145 || msg.data1 == 144)
       {  
           0=> counter;          
            
            //Looks for empty space to store midi key note
            while(id[counter]!=0) 
                counter++;
            
            //store midi note in array
            msg.data2=>id[counter]; 
            //turn note on on key press
            ON(id[counter],
            msg.data3);  }
            
            //turn note off on key release
            if( msg.data1 == 128){
                0=>counter;  
                OFF();       
                0=>id[counter];   }                  
            }	
        }
    
    
        //helper function to turn note on
        public void ON(int note, int velocity){
            synth.gain(1);
             synth.freq(Std.mtof(note));
            <<<Std.mtof(note)>>>;
	
        }
     
        
        
        //helper function to turn not off
        public void OFF(){
            synth.gain(0);
        }
        

