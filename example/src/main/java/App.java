import org.bouncycastle.jce.provider.BouncyCastleProvider;

class App
{
    public static String bcInfo() {
	return new BouncyCastleProvider().getInfo();
    }
    public static String jrubyVersion() {
	return org.jruby.runtime.Constants.VERSION;
    }
    public static String hello(String name) {
	return "hello " + name;
    }
}
