class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.3.0.tar.gz"
  sha256 "f2ed11f8fee52c89487e6e24ba6a31fa604b326e08fb0f561a22c877ebdb640d"
  revision 1

  bottle do
    sha256 "7940b87b0a3874033f5f569c9bbe6bbb010d8d9840c9ddfc4f341a018dad441e" => :catalina
    sha256 "a34e7f97ae062efd37410cf8f9dfc71ab6688989d6c5af7f361d1bd38b89e538" => :mojave
    sha256 "f0e77cfdb990b888957aa0c44f13606285d05360b4d0bf7e02b6f5d3e2cc35b6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "zbar"

  def install
    ENV.cxx11

    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    system "cmake", ".", "-DBUILD_DEMOS=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF",
                         "-DBUILD_TUTORIALS=OFF",
                         "-DUSE_DC1394=ON",
                         "-DDC1394_INCLUDE_DIR=#{Formula["libdc1394"].opt_include}",
                         "-DDC1394_LIBRARY=#{Formula["libdc1394"].opt_lib}/libdc1394.dylib",
                         "-DUSE_EIGEN3=ON",
                         "-DEigen3_DIR=#{Formula["eigen"].opt_share}/eigen3/cmake",
                         "-DUSE_GSL=ON",
                         "-DGSL_INCLUDE_DIR=#{Formula["gsl"].opt_include}",
                         "-DGSL_cblas_LIBRARY=#{Formula["gsl"].opt_lib}/libgslcblas.dylib",
                         "-DGSL_gsl_LIBRARY=#{Formula["gsl"].opt_lib}/libgsl.dylib",
                         "-DUSE_JPEG=ON",
                         "-DJPEG_INCLUDE_DIR=#{Formula["jpeg"].opt_include}",
                         "-DJPEG_LIBRARY=#{Formula["jpeg"].opt_lib}/libjpeg.dylib",
                         "-DUSE_LAPACK=ON",
                         "-DUSE_LIBUSB_1=OFF",
                         "-DUSE_OPENCV=ON",
                         "-DOpenCV_DIR=#{Formula["opencv"].opt_share}/OpenCV",
                         "-DUSE_PCL=ON",
                         "-DUSE_PNG=ON",
                         "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
                         "-DPNG_LIBRARY_RELEASE=#{Formula["libpng"].opt_lib}/libpng.dylib",
                         "-DUSE_PTHREAD=ON",
                         "-DPTHREAD_INCLUDE_DIR=#{sdk}/usr/include",
                         "-DPTHREAD_LIBRARY=/usr/lib/libpthread.dylib",
                         "-DUSE_PYLON=OFF",
                         "-DUSE_REALSENSE=OFF",
                         "-DUSE_REALSENSE2=OFF",
                         "-DUSE_X11=OFF",
                         "-DUSE_XML2=ON",
                         "-DXML2_INCLUDE_DIR=#{sdk}/usr/include/libxml2",
                         "-DXML2_LIBRARY=/usr/lib/libxml2.dylib",
                         "-DUSE_ZBAR=ON",
                         "-DZBAR_INCLUDE_DIRS=#{Formula["zbar"].opt_include}",
                         "-DZBAR_LIBRARIES=#{Formula["zbar"].opt_lib}/libzbar.dylib",
                         "-DUSE_ZLIB=ON",
                         "-DZLIB_INCLUDE_DIR=#{sdk}/usr/include",
                         "-DZLIB_LIBRARY_RELEASE=/usr/lib/libz.dylib",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <visp3/core/vpConfig.h>
      #include <iostream>
      int main()
      {
        std::cout << VISP_VERSION_MAJOR << "." << VISP_VERSION_MINOR <<
                "." << VISP_VERSION_PATCH << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").chomp
  end
end
