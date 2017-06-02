
public class WetSynth extends Chugen
{
    TriOsc osc[2];
    0.5 => osc[0].gain;
    0.5 => osc[1].gain;
    
    Gain g => ADSR e;


e.set(10::ms, 8::ms, 0.5, 100::ms);

public void gain(float x)
{
    x => g.gain;
}

public void freq(float f)
{
    (1.005)*f => osc[0].freq;
    (0.995)*f => osc[1].freq;
}

public void connect(UGen ugen)
{
    e => ugen;
}

public void disconnect(UGen ugen)
{
    e =< ugen;
}

public void keyOn()
{
    e.keyOn();
}

public void keyOff()
{
    e.keyOff();
}
}

WetSynth synth;
MidiIn min;
MidiMsg msg;
//Make a ring buffer of available synths, and a lookup table of synths in use
WetSynth @ synthsInUse[128];
WetSynth availableSynths[5];
0 => int nextSynth;
availableSynths.cap()-1 => int lastSynth;

int id[100];          // Array to store notes currently being played
int  counter;   

//Initialize synths
0 => int device;

min.open( device );  // opens midi device

while( true ){
    // Listens for midi event
    min => now;
    
    //Process midi data 
    while( min.recv( msg ) ){
        
        //Debug statements, uncomment ot print out device input data
        //<<<msg.data1, msg.data2, msg.data3>>>;
        
        //left wheel
        if (msg.data1 == 224) {
            //msg.data3/127.0 => p.pan;           
        }
        
        //right wheel and nobs
        if (msg.data1 == 176) {
            //right wheel
            if(msg.data2 == 1) {
              //  msg.data3/127.0 => p.gain;
            }
            
            //Top nob 1
            if(msg.data2 == 20) {
               // msg.data3/127.0 => sines.gain;
            }
            
            //Top nob 2
            if(msg.data2 == 21) {
              //  msg.data3/127.0 => harmony.gain;
            }
            
            if(msg.data2 == 22) {
              //  msg.data3/127.0 => piano.gain;
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
              //  0 => harmony.pos;
            } 
            //pad 3
            else if(msg.data2 == 42) {
             //   0 => piano.pos;
            } 
            
            //pad 4
            else if(msg.data2 == 46) {
            //    0 => metronome.pos;
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
        
        public void ON(int note, int velocity){
            synth=>dac;                       
            Std.mtof( note ) => synth.freq;    
            .5 => synth.gain;
            synth.keyOn();
            
        }
        
        
        //helper function to turn not off
        public void OFF(){
            synth =< dac;
            synth.keyOff();  
        }
