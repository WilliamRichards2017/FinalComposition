SndBuf kick => dac;
SndBuf snare => dac;
SndBuf hihat => dac;



me.dir() + "audio/kick.wav" => kick.read;
me.dir() + "audio/snare.wav" => snare.read;
me.dir() + "audio/hihat.wav" => hihat.read;


[1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0] @=> int kickHits[];
[0,0,1,0,0,0,1,0,0,0,0,0,1,1,1,1] @=> int snareHits[];

0.2 => hihat.gain;

0.15::second => dur tempo;

spork ~ drum_machine();
 1::day => now;

public void drum_machine() {
    while(true){ 
        0 => int beat;
        
        while(beat < kickHits.cap())
        {
            if(kickHits[beat])
            {
                0 => kick.pos;
            }
            if (snareHits[beat]){
                0 => snare.pos;
            }
            1 => hihat.pos;
            tempo => now;
            beat++;
        }
    }
}