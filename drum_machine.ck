/* Will Richards, Bobby Volpendesta
 *  Final  composition
 *  
 * Drum machine class
 * Has bare bones hid listener for looping and volume control
 * 
 */

SndBuf kick => dac;
SndBuf snare => dac;
SndBuf hihat => dac;

Hid hi;
HidMsg msg;

// which keyboard

0 => int dcount;

fun void hid_listen(){

    0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
while( true )
{
    // wait for event
    hi => now;
    
    <<<msg.which>>>;
    // get message
    while( hi.recv( msg ) )
    {
        // check
        if (msg.which==30) {
            
            (dcount +1) % 3 => dcount;
            <<<dcount>>>;

            
            }
            
            else if (msg.which == 82) {
                kick.gain() => float temp;
                .1 +=> temp;
                kick.gain(temp);
                snare.gain(temp);
                hihat.gain(temp);

            }
            
            else if (msg.which == 81) {
                kick.gain() => float temp;
                .1 -=> temp;
                if (temp < 0){
                    0 => temp;
                    }
                kick.gain(temp);
                snare.gain(temp);
                hihat.gain(temp);
                
            }
            
            
            
        }    
    }
}



//Drum pattern 1
[1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0] @=> int kickHits1[];
[0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0] @=> int snareHits1[];
[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0] @=> int hihatHits1[];

//Drum pattern 2
[1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0] @=> int kickHits2[];
[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0] @=> int snareHits2[];
[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0] @=> int hihatHits2[];

//Drum pattern 3
[1,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0] @=> int kickHits3[];
[0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0] @=> int snareHits3[];
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] @=> int hihatHits3[];

//Set gain really low, we can increase gain during program
0.05 => hihat.gain;
0.05 => kick.gain;
0.05 => snare.gain;


0.08::second => dur tempo;

kick => dac;
snare => dac;
hihat => dac;

me.dir() + "audio/kick.wav" => kick.read;
me.dir() + "audio/snare.wav" => snare.read;
me.dir() + "audio/hihat.wav" => hihat.read;

//Plays whatever drum loop is selected by hid_listener
fun void drum_machine() {

        //There is a much better way to write this control structure
        //But this is a workaround, as we cannot figure out multidimentional arrays in chuck
    while(true){ 
        0 => int beat; 
        
        //Play beat 1
        if(dcount == 0)
        {
            while(beat < kickHits1.cap())
            {
                if(kickHits1[beat])
                {
                    0 => kick.pos;
                }
                if (snareHits1[beat])
                {
                    0 => snare.pos;
                }
                if(hihatHits1[beat]){
                    0 => hihat.pos;
                }
                tempo => now;
                beat++;
            }
        }
        //Play beat 2
        else if (dcount==1){
            while(beat < kickHits2.cap())
            {
                if(kickHits2[beat])
                {
                    0 => kick.pos;
                }
                if (snareHits2[beat]){
                    0 => snare.pos;
                }
                
                if(hihatHits2[beat]){
                    0 => hihat.pos;
                }
                tempo => now;
                beat++;
            }
        }
        else if (dcount==2){
            while(beat < kickHits3.cap())
            {
                if(kickHits3[beat])
                {
                    0 => kick.pos;
                }
                if (snareHits3[beat])
                {
                    0 => snare.pos;
                }
                if(hihatHits3[beat])
                {
                    0 => hihat.pos;
                }
                tempo => now;
                beat++;
            }
        }             
    }    
}

//Listen for keyboard input               
spork ~ hid_listen();
//Play propper drum loop
spork ~ drum_machine();
1::day => now;



