import 'package:bestapp_package/bestapp_package.dart';
import 'package:flutter/material.dart';

class PullingLoading extends StatefulWidget {
  final Widget child;
  final Function onRefresh;
  final Function? onLoadmore;
  final bool reverse;
  final bool enablePullDown;
  final bool reverColor;
  final Color? headerBgcolor;
  
  final RefreshController refreshController;
  const PullingLoading({ 
    Key? key,
    required this.child,
    required this.refreshController,
    required this.onRefresh,
    this.reverse=false,
    this.enablePullDown = true,
    this.reverColor = false,
    this.headerBgcolor,
    this.onLoadmore
   }) : super(key: key);

  @override
  State<PullingLoading> createState() => _PullingLoadingState();
}

class _PullingLoadingState extends State<PullingLoading> with TickerProviderStateMixin {
  late AnimationController anicontroller, _scaleController;

  @override
  void initState() {
    super.initState();
    anicontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _scaleController = AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    // widget.refreshController.headerMode.addListener(() {
    //   if (widget.refreshController.headerStatus == RefreshStatus.idle) {
    //     _scaleController.value = 0.0;
    //     _anicontroller.reset();
    //   } else if (widget.refreshController.headerStatus == RefreshStatus.refreshing) {
    //     _anicontroller.repeat();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      child: widget.child,
      onRefresh: widget.onRefresh as void Function()?,
      onLoading: widget.onLoadmore as void Function()?,
      controller: widget.refreshController,
      enablePullDown: widget.enablePullDown,
      reverse: widget.reverse,
      enablePullUp: widget.onLoadmore != null ? true : false,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode){
          Widget body;
          // if(mode==LoadStatus.idle){
          //   body =  Text("pull up load");
          // }
          if(mode==LoadStatus.loading){
            body = Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: beloadCircular(
                color: Theme.of(context).primaryColor,
              )
            );
          }
          else if(mode == LoadStatus.failed){
            body = Text("Load Failed!Click retry!");
          }
          else if(mode == LoadStatus.canLoading){
            // body = Text("release to load more");
            body = Container();
          }
          else{
            // body = Text("No more Data");
            body = Container();
          }
          return Container(
            height: 55.0,
            child: Center(child:body),
          );
        },
      ),
      header: CustomHeader(
        refreshStyle: RefreshStyle.Behind,
        onOffsetChange: (offset) {
          if (widget.refreshController.headerMode!.value != RefreshStatus.refreshing)
            _scaleController.value = offset / 80.0;
        },
        builder: (c, m) {
          return Container(
            color: widget.reverColor ? Theme.of(context).scaffoldBackgroundColor : widget.headerBgcolor != null ? widget.headerBgcolor :  Theme.of(context).primaryColor,
            child: FadeTransition(
              opacity: _scaleController,
              child: ScaleTransition(
                child: Container(
                  child: beloadCircular(
                    color: widget.reverColor ? 
                    widget.headerBgcolor != null ? widget.headerBgcolor :  Theme.of(context).primaryColor
                    : Colors.white
                  )
                ),
                scale: _scaleController,
              ),
            ),
            alignment: Alignment.center,
          );
        },
      )
    );
  }
}