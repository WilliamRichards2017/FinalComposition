 public class MyCosine extends Chugen
{
    0 => int p;
    440 => float f;
    second/samp => float SRATE;
    
    fun float tick(float in)
    {
        return Math.cos(p++*2*pi*f/SRATE);
    }
}