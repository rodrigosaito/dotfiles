{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubectl-neat";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "itaysk";
    repo = "kubectl-neat";
    rev = "v${version}";
    sha256 = "0nac1k4c4gm681a756zzpgsixwsjppsn92595pk7ra61j36g9jwg";
  };

  vendorSha256 = "1k3qkgfh2r1ig68mlbkcr78sbrnc5kz3gi9z0isxakq33mhyhrdw";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Remove clutter from Kubernetes manifests to make them more readable.";
    homepage = "https://github.com/itaysk/kubectl-neat";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
