import org.bouncycastle.jce.provider.BouncyCastleProvider;

class App
{

    public App()
    {
	System.out.println( new BouncyCastleProvider().getInfo() );
    }

}
