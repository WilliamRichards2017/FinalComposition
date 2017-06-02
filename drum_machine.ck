SndBuf kick => dac;
SndBuf snare => dac;
SndBuf hihat => dac;

Hid hi;
HidMsg msg;

// which keyboard

0 => int dcount;

fun void midi_listen(){

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
    }
}
}
spork ~ midi_listen();
spork ~ drum_machine();
1::day => now;



[1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0] @=> int kickHits1[];
[0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0] @=> int snareHits1[];
[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0] @=> int hihatHits1[];

[1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0] @=> int kickHits2[];
[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0] @=> int snareHits2[];
[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0] @=> int hihatHits2[];

[1,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0] @=> int kickHits3[];
[0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0] @=> int snareHits3[];
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] @=> int hihatHits3[];



0.2 => hihat.gain;
0.2 => kick.gain;
0.2 => snare.gain;
0.08::second => dur tempo;

     
    kick => dac;
    snare => dac;
     hihat => dac;
    
me.dir() + "audio/kick.wav" => kick.read;
me.dir() + "audio/snare.wav" => snare.read;
me.dir() + "audio/hihat.wav" => hihat.read;

fun void drum_machine() {

    while(true){ 
        0 => int beat;
        
        <<<"what is doucnt">>>;
        <<<dcount>>>;
        if(dcount == 0){

            while(beat < kickHits1.cap())
            {
                if(kickHits1[beat])
                {
                    0 => kick.pos;
                }
                if (snareHits1[beat]){
                    0 => snare.pos;
                }
                //1 => hihat.pos;
                if(hihatHits1[beat]){
                    0 => hihat.pos;
                }
                tempo => now;
                beat++;
            }

            
            }
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
                    //1 => hihat.pos;
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
                        if (snareHits3[beat]){
                            0 => snare.pos;
                        }
                        //1 => hihat.pos;
                        if(hihatHits3[beat]){
                            0 => hihat.pos;
                        }
                        tempo => now;
                        beat++;
                    }

                    }          
                
                }
                
            }
                
    


