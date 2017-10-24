class Vipergen < Formula
    desc "A tool to generate VIPER modules"
    homepage "https://github.com/che1404/Vipergen"
    url "https://github.com/che1404/Vipergen/archive/0.1.0.tar.gz"
    version "0.1.0"
    sha256 "f90428139ae9a8306f6c1dd2dbce1749fc0444031d724ca8c294d04dc93aec91"
    head "https://github.com/che1404/Vipergen.git"
    
    depends_on :xcode => "9.0"
    
    def install
        ENV.deparallelize
        system "make"  # separate make and make install steps
        system "make", "install"
    end

end
