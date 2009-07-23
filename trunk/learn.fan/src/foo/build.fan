using build

class Build: BuildPod {
	
	override Void setup(){
		
		podName = "foo"
		description = "foo pod by wangzx"
		version = globalVersion
		depends = ["sys 1.0+"]
		srcDirs = [`fan/foo/`]
	}
}