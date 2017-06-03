/* Will Richards, Bobby Volpendesta
 *  Final  composition
 *  Computer music and sound
 *
 * Main midi controller class
 * Organ sound is created in our custom ugen cos
 * Delay and echo effects are added outside the ugen
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
    0.5 => float g;
    second/samp => float SRATE;
    
    fun float tick(float in)
    {
        return Math.cos(((count++)*50)*2*pi*f/SRATE);
    }
    
    fun void freq(float frequency){
        frequency => f;
    }
    
    

}

//Declare sound chain
cos synth => JCRev r => Echo e => Gain g => Echo e2 => Pan2 p => dac;

synth.gain(0);

// set delays
240::ms => e.max => e.delay;
480::ms => e2.max => e2.delay;
// set gains
.6 => e.gain;
.3 => e2.gain;
.05 => r.mix;  
  //Sound that will control the midi keyboard 
int id[100000];          // Array to store notes currently being played
int  counter;        // Counter to see how many notes we are currently playing

//Midi divice port
0 => int device;

//Load in sound buffs
SndBuf tom => dac;
SndBuf gun => dac;
SndBuf stab1 => dac;
SndBuf horns => dac;

me.dir() + "audio/gun.wav" => gun.read;
me.dir() + "audio/tom.wav" => tom.read;
me.dir() + "audio/stab1.wav" => stab1.read;
me.dir() + "audio/horns.wav" => horns.read;



stab1.samples() => stab1.pos;
horns.samples() => horns.pos;
gun.samples() => gun.pos;
tom.samples() => tom.pos;

1 => stab1.gain;



min.open( device );  // opens midi device

while( true )
{
    // Listens for midi event
    min => now;
    
    //Process midi data 
    while( min.recv( msg ) ){
        
        //Debug statements, uncomment ot print out device input data
        //<<<msg.data1, msg.data2, msg.data3>>>;
        
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
               g.gain(msg.data3/127.0);
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
        else if( msg.data1 == 153) 
        {
            //pad 1
            if(msg.data2 == 49) 
            {
                2 => tom.rate;
                0 => tom.pos;
            }
            //pad 2
            else if(msg.data2 == 41) 
            {
                1.6 => tom.rate;
                0 => tom.pos;          
            } 
            //pad 3
            else if(msg.data2 == 42)
            {
                1.2 => tom.rate;
                0 => tom.pos;     
            } 
            
            //pad 4
            else if(msg.data2 == 46) {
                1 => tom.rate;
                0 => tom.pos;
            } 
            
            else if(msg.data2 == 36) 
            {
                1 => stab1.rate;
                0 => stab1.pos;
            }  
            
            //pad 5
            else if(msg.data2 == 37)
            {
                1.2 => stab1.rate;
                0 => stab1.pos;
            }  
            //pad 7
            else if(msg.data2 == 38)
            {
                0 => gun.pos;
            } 
            
            //pad 8
            else if(msg.data2 == 39)
            {
                0 => horns.pos;
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
            if( msg.data1 == 128)
            {
                0=>counter;  
                OFF();       
                0=>id[counter];
            }                  
        }	
    }
    
    //helper function to turn note on, custom integrated into ugen
    public void ON(int note, int velocity){
        synth.gain(5);
        //Wierd off by 1 error due to our ugen code
        synth.freq(Std.mtof(note+1));
        // <<<Std.mtof(note)>>>;
    }
    
    //helper function to turn not off
    public void OFF(){
        synth.gain(0);
    }
    
        
