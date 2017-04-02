<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="renderer" content="webkit"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>我的购物车 - XBin商城</title>

    <!-- Start: injected by Adguard -->
    <script src="//local.adguard.com/adguard-ajax-api/injections/content-script.js?sb=1&ts=1487722296.704474&js=1&domain=cart.jd.com&css=1&generic=1"
            type="text/javascript" crossorigin="anonymous"></script>
    <script src="//local.adguard.com/adguard-ajax-api/injections/userscripts/Adguard Assistant?ts=1487722293.799811"
            type="text/javascript" crossorigin="anonymous"></script>
    <!-- End: injected by Adguard -->
    <link type="text/css" rel="stylesheet" href="/css/cart.css"/>
    <script type="text/javascript" src="//misc.360buyimg.com/jdf/lib/jquery-1.6.4.js"></script>
    <script type="text/javascript" src="//misc.360buyimg.com/jdf/1.0.0/unit/base/1.0.0/base.js"></script>
    <link source="widget" href="//misc.360buyimg.com/user/cart/??/widget/no-login/no-login.css" rel="stylesheet"
          type="text/css">
    <link type="text/css" rel="stylesheet" href="/css/common.css" source="widget"/>

    <script type="text/javascript">
        try {
            window._alysAA = window._alysAA || [];
            var _alysAA = window._alysAA;
            _alysAA.push(['init', 'ifc', 'T-000014-01']);
            ;
            (function () {
                var idgJsPath = "//misc.360buyimg.com/lib/js/2012";
                var ga = document.createElement('script');
                ga.type = 'text/javascript';
                ga.async = true;
                ga.src = idgJsPath + '/idigger.js';
                var s = document.getElementsByTagName('script')[0];
                s.parentNode.insertBefore(ga, s);
            })();
        } catch (err) {
        }

        function StandardPost(url, args) {
            var form = $("<form method='post'></form>");
            form.attr({"action": url});
            for (arg in args) {
                var input = $("<input type='hidden'>");
                input.attr({"name": 'cartInfos'});
                input.val(args[arg]);
                form.append(input);
            }
            form.submit();
        }

        function gotoOrder() {
            var ids = "";
            var indexs = "";
            var nums = "";
            var form = $("#gotoOrder");
            $("[name='checkItem'][checked]").each(function () {
                var id = $(this).attr('value');

                var index = $("#check" + id).attr('index');
                var num = $('#changeQuantity' + id).attr('value');
                ids += $(this).val() + ",";
                indexs += index + ",";
                nums += num + ",";

            });
            if(ids.length == 0) {
                ids = "";
                indexs = "";
                nums = "";
                return;
            }
            var inputIds = $("<input type='hidden' name='ids'>");
            var inputIndexs = $("<input type='hidden' name='indexs'>");
            var inputNums = $("<input type='hidden' name='nums'>");
            inputIds.val(ids);
            inputIndexs.val(indexs);
            inputNums.val(nums);
            form.append(inputIds);
            form.append(inputIndexs);
            form.append(inputNums);
//            alert(ids);
//            alert(indexs);
//            alert(nums);

            form.submit();
        }
        function check(id) {
            //判断是否选中
            var check = $("#check" + id).is(':checked');
            //商品总价对象
            var totalPrice = $('#totalPrice');
            //商品总数对象
            var amountSum = $('#amount-sum');
            //商品总数
            var amountSumValue = parseInt(amountSum.text());
            //勾线商品总价
            var totalValue = parseInt(totalPrice.attr('value'));
            //单独商品总价对象
            var sum = $('#p-sum' + id);
            //单独商品总价
            var sumValue = parseInt(sum.attr('value'));
            var selected = $('#product_' + id);
            //是否被选中
            if (check) {
                //设置商品被选中
                $("#check" + id).attr('checked', 'checked');
                //更改全部商品总价
                totalPrice.attr('value', totalValue + sumValue);
                //更改全部商品总价显示
                totalPrice.text('￥' + ((totalValue + sumValue) / 100).toFixed(2));
                //商品选中数量加1
                amountSum.text(amountSumValue + 1);
                selected.addClass('item-selected');
            } else {
                //移除商品被选中
                $("#check" + id).removeAttr('checked');
                //更改全部商品总价
                totalPrice.attr('value', totalValue - sumValue);
                //更改全部商品总价显示
                totalPrice.text('￥' + ((totalValue - sumValue) / 100).toFixed(2));
                //商品选中数量减1
                amountSum.text(amountSumValue - 1);
                selected.removeClass('item-selected');
            }
        }
        ;

        //减少商品
        function decrement(id) {
            var check = $("#check" + id).is(':checked');

            var quantity = $('#changeQuantity' + id);
            var nub = parseInt(quantity.val());

            if (nub == 1) {
                return;
            }

            $.post("/decreOrIncre.action",
                    {
                        pid: id,
                        pcount: 1,
                        type: 2,
                        index: $("#check" + id).attr('index')
                    }
                    , function (data) {
                        if (data && data.status == 400) {
                            alert(data.error);
                        }
                    }).error(function () {
                alert('服务器添加数量失败!');
            });

            quantity.val(nub - 1);
            var price = parseInt($('#p-price' + id).attr('value'));
//            alert(price);
            var sum = $('#p-sum' + id);

            var sumPrice = $('#p-sum' + id);
            sumPrice.attr('value', price * (nub - 1));

            if (check) {
                var totalPrice = $('#totalPrice');
                //总价
                var totalPriceValue = parseInt($('#totalPrice').attr('value'));
                var totalValue = totalPriceValue - price;
                totalPrice.text('￥' + (totalValue / 100).toFixed(2));
                totalPrice.attr('value', totalValue);
            }
//            alert(pricesum);
            var pricesum = price * (nub - 1) / 100;
            sum.text('￥' + pricesum.toFixed(2));

            if (nub - 1 == parseInt(quantity.attr('minnum'))) {
                $('#decrement' + id).addClass('disabled');
            }
        }

        //增加商品
        function increment(id) {

            var check = $("#check" + id).is(':checked');

            var quantity = $('#changeQuantity' + id);
            var nub = parseInt(quantity.val());

            $.post("/decreOrIncre.action",
                    {
                        pid: id,
                        pcount: 1,
                        type: 1,
                        index: $("#check" + id).attr('index')
                    }
                    , function (data) {
                        if (data && data.status == 400) {
                            alert(data.error);
                        }
                    }).error(function () {
                alert('服务器添加数量失败!');
            });

            quantity.val(parseInt(quantity.val()) + 1);
            $('#decrement' + id).removeClass('disabled');

            var price = parseInt($('#p-price' + id).attr('value'));
//            alert(price);
            var sum = $('#p-sum' + id);
            if (check) {
                var totalPrice = $('#totalPrice');
                //总价
                var totalPriceValue = parseInt($('#totalPrice').attr('value'));
                var totalValue = totalPriceValue + price;
                totalPrice.text('￥' + (totalValue / 100).toFixed(2));
                totalPrice.attr('value', totalValue);
            }

            var sumPrice = $('#p-sum' + id);
            sumPrice.attr('value', price * (nub + 1));
            var pricesum = price * (nub + 1) / 100;
//            alert(pricesum);
            sum.text('￥' + pricesum.toFixed(2));
        }

    </script>
</head>
<body>
<div id="shortcut-2014">
    <div class="w">
        <ul class="fl">
            <li class="dorpdown" id="ttbar-mycity"></li>
        </ul>
        <ul class="fr">
            <li class="fore1" id="ttbar-login">
                <a href="javascript:login();" class="link-login">你好，请登录</a>&nbsp;&nbsp;<a href="javascript:regist();"
                                                                                          class="link-regist style-red">免费注册</a>
            </li>
            <li class="spacer"></li>
            <li class="fore2">
                <div class="dt">
                    <a target="_blank" href="//order.jd.com/center/list.action">我的订单</a>
                </div>
            </li>
            <li class="spacer"></li>
            <li class="fore3 dorpdown" id="ttbar-myjd">
                <div class="dt cw-icon">
                    <i class="ci-right"><s>◇</s></i>
                    <a target="_blank" href="//home.jd.com/">我的XBin</a>
                </div>
                <div class="dd dorpdown-layer"></div>
            </li>
            <li class="spacer"></li>
            <li class="fore4">
                <div class="dt">
                    <a target="_blank" href="//vip.jd.com/">XBin会员</a>
                </div>
            </li>
            <li class="spacer"></li>
            <li class="fore5">
                <div class="dt">
                    <a target="_blank" href="//b.jd.com/">企业采购</a>
                </div>
            </li>
            <li class="spacer"></li>
            <li class="fore6 dorpdown" id="ttbar-apps">
                <div class="dt cw-icon">
                    <i class="ci-left"></i>
                    <i class="ci-right"><s>◇</s></i>
                    <a target="_blank" href="//app.jd.com/">手机XBin</a>
                </div>
            </li>
            <li class="spacer"></li>
            <li class="fore7 dorpdown" id="ttbar-atte">
                <div class="dt cw-icon">
                    <i class="ci-right"><s>◇</s></i>关注XBin
                </div>
            </li>
            <li class="spacer"></li>
            <li class="fore8 dorpdown" id="ttbar-serv">
                <div class="dt cw-icon">
                    <i class="ci-right"><s>◇</s></i>客户服务
                </div>
                <div class="dd dorpdown-layer"></div>
            </li>
            <li class="spacer"></li>
            <li class="fore9 dorpdown" id="ttbar-navs">
                <div class="dt cw-icon">
                    <i class="ci-right"><s>◇</s></i>网站导航
                </div>
                <div class="dd dorpdown-layer"></div>
            </li>
        </ul>
        <span class="clr"></span>
    </div>
</div>
<div id="o-header-2013">
    <div id="header-2013" style="display:none;"></div>
</div>
<div class="w w1 header clearfix">
    <div id="logo-2014">
        <a href="http://www.jd.com/" class="logo"></a>
        <a href="#none" class="link2"><b></b>购物车</a>
    </div>
    <div class="cart-search">
        <div class="form">
            <input id="key" type="text" class="itxt" autocomplete="off" accesskey="s">
            <input type="button" class="button" value="搜索" clstag="clickcart|keycount|xincart|cart_search"
                   onclick="javascript:void(0);">
        </div>
    </div>
</div>


<!-- main -->
<div id="container" class="cart">
    <c:choose>

    <c:when test="${cartInfos == null}">
        <div class="w">
            <div id="chunjie" class="mb10"></div>
            <div class="cart-empty">
                <div class="message">
                    <ul>
                        <li class="txt">
                            购物车内暂时没有商品，登录后将显示您之前加入的商品
                        </li>
                        <li>
                            <a href="http://localhost:8104/login.html" class="btn-1 login-btn mr10">登录</a>
                            <a href="http://localhost:8101" class="ftx-05">
                                去购物&gt;
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
    <div class="w">
        <div id="chunjie" class="mb10"></div>
        <div class="cart-filter-bar">
            <ul class="switch-cart">
                <li class="switch-cart-item curr">
                    <a href="#none">
                        <em>全部商品</em>
                        <span class="number">${cartInfos.size()}</span>
                    </a>
                </li>
                    <%--<li class="switch-cart-item ui-switchable-selected">--%>
                    <%--<a class="" href="//cart.yiyaojd.com/cart">--%>
                    <%--<em>XBin大药房</em>--%>
                    <%--</a>--%>
                    <%--</li>--%>
            </ul>
            <div class="cart-store">
                <input id="hiddenLocationId" type="hidden">
                <input id="hiddenLocation" type="hidden">
                    <%--<span class="label">配送至：</span>--%>
                <div id="jdarea" class="ui-area-wrap">
                    <div class="ui-area-text-wrap">
                        <div class="ui-area-text">
                        </div>
                        <b>
                        </b>
                    </div>
                    <div class="ui-area-content-wrap">
                        <div class="ui-area-tab">
                        </div>
                        <div class="ui-area-content" clstag="clickcart|keycount|xincart|cart_changeArea">
                        </div>
                    </div>
                </div>
            </div>
            <div class="clr"></div>
            <div class="w-line">
                <div class="floater"></div>
            </div>
            <div class="tab-con"></div>
            <div class="tab-con hide"></div>
        </div>
    </div>
    <div class="cart-warp">
        <div class="w">
            <div id="jd-cart">
                <div class="cart-main cart-main-new">
                    <div class="cart-thead">
                        <div class="column t-checkbox">
                            <div class="cart-checkbox">
                                <input type="checkbox" checked="checked" id="toggle-checkboxes_up"
                                       name="toggle-checkboxes" class="jdcheckbox"
                                       clstag="clickcart|keycount|xincart|cart_allCheck">
                                <label class="checked" for="">勾选全部商品</label>
                            </div>
                            全选
                        </div>
                        <div class="column t-goods">商品</div>
                        <div class="column t-props"></div>
                        <div class="column t-price">单价</div>
                        <div class="column t-quantity">数量</div>
                        <div class="column t-sum">小计</div>
                        <div class="column t-action">操作</div>
                    </div>
                    <div id="cart-list">
                        <form id="gotoOrder" method='post' action='http://localhost:8108/order/getOrderInfo.action'></form>
                        <div class="cart-item-list" id="cart-item-list-01">
                            <div class="cart-tbody" id="vender_8888">
                                <div class="shop">
                                    <div class="cart-checkbox">
                                        <input type="checkbox" checked="checked" name='checkShop' class="jdcheckbox"
                                               clstag="clickcart|keycount|xincart|cart_checkOn_shop">
                                        <label for="">勾选店铺内全部商品</label>
                                    </div>
                                    <span class="shop-txt">
												<a class="shop-name self-shop-name" href="javascript:;"
                                                   id="venderId_8888"
                                                   clstag="clickcart|keycount|xincart|cart_shopNameJD">自营</a>
									</span>
                                </div>
                                <div class="item-list">
                                    <c:forEach items="${cartInfos}" var="c" varStatus="status">
                                        <div class="item-give item-full " id="product_promo_${c.id}">
                                            <!-- 单品-->
                                            <div class=" item-last item-item item-selected  " id="product_${c.id}">
                                                <div class="item-form">
                                                    <div class="cell p-checkbox">
                                                        <div class="cart-checkbox">
                                                            <input id="check${c.id}" index="${status.index}"
                                                                   type="checkbox" name='checkItem' value="${c.id}"
                                                                   checked="checked" onclick="check('${c.id}')">
                                                            <label for="" class="checked">勾选商品</label>
                                                        </div>
                                                    </div>
                                                    <div class="cell p-goods">
                                                        <div class="goods-item">
                                                            <div class="p-img">
                                                                <a href="http://localhost:8103/item/${c.id}.html"
                                                                   target='_blank'
                                                                   class="J_zyyhq_${c.id}"><img
                                                                        alt="${c.name}"
                                                                        clstag="clickcart|keycount|xincart|cart_sku_pic"
                                                                        src="${c.imageUrl}" height="80" width="80"></a>
                                                            </div>
                                                            <div class="item-msg">
                                                                <div class="p-name">
                                                                    <a clstag="clickcart|keycount|xincart|cart_sku_name"
                                                                       href="http://localhost:8103/item/${c.id}.html"
                                                                       target='_blank'>
                                                                            ${c.name}
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="cell p-props p-props-new">
                                                        <div class="props-txt" title="${c.colour}">颜色：${c.colour}</div>
                                                        <div class="props-txt" title="${c.size}">尺码：${c.size}</div>
                                                    </div>
                                                    <div class="cell p-price">
                                                        <strong id="p-price${c.id}"
                                                                value="${c.price}">¥<fmt:formatNumber
                                                                groupingUsed="false"
                                                                maxFractionDigits="2"
                                                                minFractionDigits="2"
                                                                value="${c.price / 100 }"/></strong>
                                                    </div>
                                                    <div class="cell p-quantity">
                                                        <!-- 满赠 -->
                                                        <div class="quantity-form" promoid="196031044">
                                                            <a href="javascript:void(0);"
                                                               clstag="clickcart|keycount|xincart|cart_num_down"
                                                               class="decrement <c:if test="${c.num ==1}">disabled</c:if>"
                                                               id="decrement${c.id}"
                                                               onclick="decrement('${c.id}')">-</a>
                                                            <input autocomplete="off" type="text" class="itxt"
                                                                   value="${c.num}"
                                                                   id="changeQuantity${c.id}"
                                                                   minnum="1"/>
                                                            <a href="javascript:void(0);"
                                                               clstag="clickcart|keycount|xincart|cart_num_up"
                                                               class="increment"
                                                               id="increment${c.id}"
                                                               onclick="increment('${c.id}')">+</a>
                                                        </div>
                                                        <div class="ac ftx-03 quantity-txt"
                                                             _stock="stock_${c.id}">有货
                                                        </div>

                                                    </div>
                                                    <div class="cell p-sum">
                                                        <strong id="p-sum${c.id}" value="${c.sum}">¥<fmt:formatNumber
                                                                groupingUsed="false"
                                                                maxFractionDigits="2"
                                                                minFractionDigits="2"
                                                                value="${c.sum / 100 }"/></strong>
                                                        <span class="weight" id="weight_${c.id}" data="0.39" fresh=""
                                                              skuId="3133817" num="1"></span>
                                                    </div>
                                                    <div class="cell p-ops">
                                                        <!-- 满赠 -->
                                                        <a id="remove_8888_${c.id}_13_196031044"
                                                           clstag="clickcart|keycount|xincart|cart_sku_del"
                                                           data-name="${c.name}"
                                                           class="cart-remove"
                                                           href="javascript:void(0);">删除</a>
                                                        <a href="javascript:void(0);" class="cart-follow"
                                                           id="follow_8888_${c.id}_13_196031044"
                                                           clstag="clickcart|keycount|xincart|cart_sku_guanzhu">移到我的关注</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="cart-floatbar">
                <div class="cart-toolbar">
                    <div class="toolbar-wrap">
                        <div class="selected-item-list hide">
                        </div>
                        <div class="options-box">
                            <div class="select-all">
                                <div class="cart-checkbox">
                                    <input type="checkbox" checked="checked" id="toggle-checkboxes_down"
                                           name="toggle-checkboxes" class="jdcheckbox"
                                           clstag="clickcart|keycount|xincart|cart_allCheckDown">
                                    <label class="checked" for="">勾选全部商品</label>
                                </div>
                                全选
                            </div>
                            <div class="operation">
                                <a href="#none" clstag="clickcart|keycount|xincart|cart_somesku_del"
                                   class="remove-batch">删除选中的商品</a>
                                <a href="#none" class="follow-batch"
                                   clstag="clickcart|keycount|xincart|cart_somesku_guanzhu">移到我的关注</a>
                                <a class="J_clr_nosale" href="#none" clstag="pageclick|keycount|201508251|23">清除下柜商品</a>
                            </div>
                            <div class="clr"></div>
                            <div class="toolbar-right">
                                <div class="normal">
                                    <div class="comm-right">
                                        <div class="btn-area">
                                            <a href="javascript:void(0);" onclick="gotoOrder()" class="submit-btn">
                                                去结算<b></b></a>
                                        </div>
                                        <div class="price-sum">
                                            <div>
                                                <span class="txt txt-new">总价：</span>
                                                <span class="price sumPrice"><em id="totalPrice" value="${totalPrice}">¥<fmt:formatNumber
                                                        groupingUsed="false" maxFractionDigits="2" minFractionDigits="2"
                                                        value="${totalPrice/ 100 }"/></em></span>
                                                <b class="ml5 price-tips"></b>
                                                <div class="price-tipsbox" style="display: none; left: 159.85px;">
                                                    <div class="ui-tips-main">不含运费及送装服务费</div>
                                                    <span class="price-tipsbox-arrow"></span>
                                                </div>
                                                <br>
                                                <span class="txt">已节省：</span>
                                                <span class="price totalRePrice">-¥0.00</span>
                                            </div>
                                        </div>
                                        <div class="amount-sum">
                                            已选择<em id="amount-sum">${cartInfos.size()}</em>件商品<b class="up"
                                                                                                 clstag="clickcart|keycount|xincart|cart_thumbnailOpen"></b>
                                        </div>
                                        <div class="clr"></div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="cart-removed">
                <div class="r-tit">已删除商品，您可以重新购买或加关注：</div>
            </div>
        </div>
    </div>
    <div class="w">
    </div>

</div>
</c:otherwise>
</c:choose>
<input type="hidden" id="isMiscdg" value="0"/>
<input type="hidden" id="hideMiscls" value="0"/>
<!-- /main -->

<div id="service-2014">
    <div class="slogen">
		<span class="item fore1">
			<i></i><b>多</b>品类齐全，轻松购物
		</span>
        <span class="item fore2">
			<i></i><b>快</b>多仓直发，极速配送
		</span>
        <span class="item fore3">
			<i></i><b>好</b>正品行货，精致服务
		</span>
        <span class="item fore4">
			<i></i><b>省</b>天天低价，畅选无忧
		</span>
    </div>
    <div class="w">
        <dl class="fore1">
            <dt>购物指南</dt>
            <dd>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-29.html">购物流程</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-151.html">会员介绍</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-297.html">生活旅行/团购</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue.html">常见问题</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-136.html">大家电</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/index.html">联系客服</a></div>
            </dd>
        </dl>
        <dl class="fore2">
            <dt>配送方式</dt>
            <dd>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-81-100.html">上门自提</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-81.html">211限时达</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/103-983.html">配送服务查询</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/109-188.html">配送费收取标准</a></div>
                <div><a target="_blank" href="//en.jd.com/chinese.html">海外配送</a></div>
            </dd>
        </dl>
        <dl class="fore3">
            <dt>支付方式</dt>
            <dd>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-172.html">货到付款</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-173.html">在线支付</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-176.html">分期付款</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-174.html">邮局汇款</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-175.html">公司转账</a></div>
            </dd>
        </dl>
        <dl class="fore4">
            <dt>售后服务</dt>
            <dd>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/321-981.html">售后政策</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-132.html">价格保护</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/130-978.html">退款说明</a></div>
                <div><a rel="nofollow" target="_blank" href="//myjd.jd.com/repair/repairs.action">返修/退换货</a></div>
                <div><a rel="nofollow" target="_blank" href="//help.jd.com/user/issue/list-50.html">取消订单</a></div>
            </dd>
        </dl>
        <dl class="fore5">
            <dt>特色服务</dt>
            <dd>
                <div><a target="_blank" href="//help.jd.com/user/issue/list-133.html">夺宝岛</a></div>
                <div><a target="_blank" href="//help.jd.com/user/issue/list-134.html">DIY装机</a></div>
                <div><a rel="nofollow" target="_blank" href="//fuwu.jd.com/">延保服务</a></div>
                <div><a rel="nofollow" target="_blank" href="//o.jd.com/market/index.action">XBinE卡</a></div>
                <div><a rel="nofollow" target="_blank" href="//mobile.jd.com/">XBin通信</a></div>
                <div><a rel="nofollow" target="_blank" href="//s.jd.com/">XBinJD+</a></div>
            </dd>
        </dl>
        <span class="clr"></span>
    </div>
</div>
<div class="w">
    <div id="footer-2014">
        <div class="links"><a rel="nofollow" target="_blank" href="//www.jd.com/intro/about.aspx">关于我们</a>|<a
                rel="nofollow" target="_blank" href="//www.jd.com/contact/">联系我们</a>|<a rel="nofollow" target="_blank"
                                                                                        href="//www.jd.com/contact/joinin.aspx">商家入驻</a>|<a
                rel="nofollow" target="_blank" href="//jzt.jd.com">营销中心</a>|<a rel="nofollow" target="_blank"
                                                                               href="//app.jd.com/">手机XBin</a>|<a
                target="_blank" href="//club.jd.com/links.aspx">友情链接</a>|<a target="_blank"
                                                                            href="//media.jd.com/">销售联盟</a>|<a
                href="//club.jd.com/" target="_blank">XBin社区</a>|<a href="//sale.jd.com/act/FTrWPesiDhXt5M6.html"
                                                                  target="_blank">风险监测</a>|<a
                href="//sale.jd.com/act/cyeSVqiO8GB.html" target="_blank" clstag="h|keycount|2016|43">隐私政策</a>|<a
                href="//gongyi.jd.com" target="_blank">XBin公益</a>|<a href="//en.jd.com/" target="_blank">English Site</a>|<a
                href="//en.jd.com/help/question-58.html" target="_blank">Contact Us</a></div>
        <div class="copyright"><a target="_blank"
                                  href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=11000002000088"><img
                src="//img13.360buyimg.com/cms/jfs/t2293/321/1377257360/19256/c267b386/56a0a994Nf1b662dc.png"/> 京公网安备
            11000002000088号</a>&nbsp;&nbsp;|&nbsp;&nbsp;京ICP证070359号&nbsp;&nbsp;|&nbsp;&nbsp;<a target="_blank"
                                                                                                href="//img14.360buyimg.com/da/jfs/t256/349/769670066/270505/3b03e0bb/53f16c24N7c04d9e9.jpg">互联网药品信息服务资格证编号(京)-经营性-2014-0008</a>&nbsp;&nbsp;|&nbsp;&nbsp;新出发京零&nbsp;字第大120007号<br>互联网出版许可证编号新出网证(京)字150号&nbsp;&nbsp;|&nbsp;&nbsp;<a
                rel="nofollow"
                href="//img30.360buyimg.com/uba/jfs/t1036/328/1487467280/1405104/ea57ab94/5732f60aN53b01d06.jpg"
                target="_blank">出版物经营许可证</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="//misc.360buyimg.com/wz/wlwhjyxkz.jpg"
                                                                        target="_blank">网络文化经营许可证京网文[2014]2148-348号</a>&nbsp;&nbsp;|&nbsp;&nbsp;违法和不良信息举报电话：4006561155<br>Copyright&nbsp;&copy;&nbsp;2004-2017&nbsp;&nbsp;XBinJD.com&nbsp;版权所有&nbsp;&nbsp;|&nbsp;&nbsp;消费者维权热线：4006067733&nbsp;&nbsp;&nbsp;&nbsp;<a
                class="mod_copyright_license" target="_blank" href="//sale.jd.com/act/7Y0Rp81MwQqc.html">经营证照</a><br>XBin旗下网站：<a
                href="https://www.jdpay.com/" target="_blank">XBin钱包</a>
        </div>
        <div class="authentication">
            <a rel="nofollow" target="_blank" href="http://www.hd315.gov.cn/beian/view.asp?bianhao=010202007080200026">
                <img width="103" height="32" alt="经营性网站备案中心"
                     src="//img12.360buyimg.com/da/jfs/t535/349/1185317137/2350/7fc5b9e4/54b8871eNa9a7067e.png"
                     class="err-product"/>
            </a>
            <script type="text/JavaScript">function CNNIC_change(eleId) {
                var str = document.getElementById(eleId).href;
                var str1 = str.substring(0, (str.length - 6));
                str1 += CNNIC_RndNum(6);
                document.getElementById(eleId).href = str1;
            }
            function CNNIC_RndNum(k) {
                var rnd = "";
                for (var i = 0; i < k; i++) rnd += Math.floor(Math.random() * 10);
                return rnd;
            }</script>
            <a rel="nofollow" target="_blank" id="urlknet" tabindex="-1"
               href="https://ss.knet.cn/verifyseal.dll?sn=2008070300100000031&ct=df&pa=294005">
                <img border="true" width="103" height="32" onclick="CNNIC_change('urlknet')"
                     oncontextmenu="return false;" name="CNNIC_seal" alt="可信网站"
                     src="//img11.360buyimg.com/da/jfs/t643/61/1174624553/2576/4037eb5f/54b8872dNe37a9860.png"
                     class="err-product"/>
            </a>
            <a rel="nofollow" target="_blank" href="http://www.bj.cyberpolice.cn/index.do">
                <img width="103" height="32" alt="网络警察"
                     src="//img12.360buyimg.com/cms/jfs/t2050/256/1470027660/4336/2a2c74bd/56a89b8fNfbaade9a.jpg"
                     class="err-product"/>
            </a>
            <a rel="nofollow" target="_blank" href="https://search.szfw.org/cert/l/CX20120111001803001836">
                <img width="103" height="32"
                     src="//img11.360buyimg.com/da/jfs/t451/173/1189513923/1992/ec69b14a/54b8875fNad1e0c4c.png"
                     class="err-product"/>
            </a>
            <a target="_blank" href="http://www.12377.cn"><img width="103" height="32"
                                                               src="//img30.360buyimg.com/da/jfs/t1915/215/1329999964/2996/d7ff13f0/5698dc03N23f2e3b8.jpg"></a>
            <a target="_blank" href="http://www.12377.cn/node_548446.htm"><img width="103" height="32"
                                                                               src="//img14.360buyimg.com/da/jfs/t2026/221/2097811452/2816/8eb35b4b/5698dc16Nb2ab99df.jpg"></a>
        </div>
    </div>
</div>
<script type="text/javascript" src="//cart.jd.com/js/config.js?v=201611290900"></script>
<script type="text/javascript" src="//misc.360buyimg.com/user/cart/js/cart-recommend.js?v=201702131415"></script>
<script type="text/javascript" src="//misc.360buyimg.com/user/cart/js/ceilinglamp.js?v=201408281121"></script>
<script type="text/javascript" src="//static.360buyimg.com/im/js/cart/im_cart_v1.js?v=201509101804"></script>
<script type="text/javascript" src="//misc.360buyimg.com/user/cart/widget/??no-login/no-login.js"></script>
<script type="text/javascript">
    seajs.use("/js/cart.new.js?v=201702061500");
</script>
<!--统计代码 -->
<script type="text/javascript">
    (function () {
        var ja = document.createElement('script');
        ja.type = 'text/javascript';
        ja.async = true;
        ja.src = '//wl.jd.com/wl.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ja, s);
    })();
</script>

<!-- 公共头尾js end -->
<OBJECT ID="ddplugin-msie" CLASSID="CLSID:B35D742C-5983-40C1-A8C0-A7DBFA2EF05E" width="0" height="0"></OBJECT>
<embed id="ddplugin" type="application/dd-plugin" width="0" height="0">
</body>
</html>