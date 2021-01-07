<#--
This software is in the public domain under CC0 1.0 Universal plus a
Grant of Patent License.

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide. This software is distributed without any
warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software (see the LICENSE.md file). If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.
-->
<div id="apps-root" style="display:none;"><#-- NOTE: webrootVue component attaches here, uses this and below for template -->
    <input type="hidden" id="confMoquiSessionToken" value="${ec.web.sessionToken}">
    <input type="hidden" id="confAppHost" value="${ec.web.getHostName(true)}">
    <input type="hidden" id="confAppRootPath" value="${ec.web.servletContext.contextPath}">
    <input type="hidden" id="confBasePath" value="${ec.web.servletContext.contextPath}/apps">
    <input type="hidden" id="confLinkBasePath" value="${ec.web.servletContext.contextPath}/qfuncs">
    <input type="hidden" id="confUserId" value="${ec.user.userId!''}">
    <input type="hidden" id="confLocale" value="${ec.user.locale.toLanguageTag()}">
    <input type="hidden" id="confDarkMode" value="${ec.user.getPreference("QUASAR_DARK")!"false"}">
    <input type="hidden" id="confLeftOpen" value="${ec.user.getPreference("QUASAR_LEFT_OPEN")!"false"}">
    <#assign navbarCompList = sri.getThemeValues("STRT_HEADER_NAVBAR_COMP")>
    <#list navbarCompList! as navbarCompUrl><input type="hidden" class="confNavPluginUrl" value="${navbarCompUrl}"></#list>
    <#assign accountCompList = sri.getThemeValues("STRT_HEADER_ACCOUNT_COMP")>
    <#list accountCompList! as accountCompUrl><input type="hidden" class="confAccountPluginUrl" value="${accountCompUrl}"></#list>

    <#assign headerClass = "bg-black text-white">

    <#-- for layout options see: https://quasar.dev/layout/layout -->
    <#-- to build a layout use the handy Quasar tool: https://quasar.dev/layout-builder -->
    <q-layout view="hHh LpR fFf">
        <q-header reveal bordered class="${headerClass}" id="top" style="background: linear-gradient(145deg,#1976d2 11%,#0f477e 75%) !important"><q-toolbar style="font-size:15px;">
            <q-btn dense flat icon="menu" @click="drawer = !drawer"></q-btn>

            <#--
            <#assign headerLogoList = sri.getThemeValues("STRT_HEADER_LOGO")>
            <#if headerLogoList?has_content>
                <m-link href="/apps"><div class="q-mx-md q-mt-sm">
                    <img src="${sri.buildUrl(headerLogoList?first).getUrl()}" alt="Home" height="32">
                </div></m-link>
            </#if>

            <#assign headerTitleList = sri.getThemeValues("STRT_HEADER_TITLE")>
            <#if headerTitleList?has_content>
            <q-toolbar-title>${ec.resource.expand(headerTitleList?first, "")}</q-toolbar-title>
            </#if>
            -->
            <q-toolbar-title>世德ERP</q-toolbar-title>
            <#-- NOTE: tried using q-breadcrumbs but last item with q-breadcrumbs--last class makes never clickable! -->
            <#--
            <template v-for="(navMenuItem, menuIndex) in navMenuList"><template v-if="menuIndex < (navMenuList.length - 1)">
                <m-link v-if="navMenuItem.hasTabMenu" :href="getNavHref(menuIndex)" class="gt-xs">{{navMenuItem.title}}</m-link>
                <div v-else-if="navMenuItem.subscreens && navMenuItem.subscreens.length" class="cursor-pointer gt-xs">
                    {{navMenuItem.title}}
                    <q-menu anchor="bottom left" self="top left"><q-list dense style="min-width: 200px">
                        <q-item v-for="subscreen in navMenuItem.subscreens" :key="subscreen.name" :class="{'bg-primary':subscreen.active, 'text-white':subscreen.active}" clickable v-close-popup><q-item-section>
                            <m-link :href="subscreen.pathWithParams">
                                <template v-if="subscreen.image">
                                    <i v-if="subscreen.imageType === 'icon'" :class="subscreen.image" style="padding-right: 4px;"></i>
                                    <img v-else :src="subscreen.image" :alt="subscreen.title" width="18" class="invertible" style="padding-right: 4px;">
                                </template>
                                <i v-else class="fa fa-link" style="padding-right: 8px;"></i>
                                {{subscreen.title}}
                            </m-link></li>
                        </q-item-section></q-item>
                    </q-list></q-menu>
                </div>
                <m-link v-else :href="getNavHref(menuIndex)" class="gt-xs">{{navMenuItem.title}}</m-link>

                <q-icon size="1.5em" name="chevron_right" color="grey" class="gt-xs"></q-icon>
            </template></template>
            <m-link v-if="navMenuList.length > 0" :href="getNavHref(navMenuList.length - 1)" class="gt-xs">{{navMenuList[navMenuList.length - 1].title}}</m-link>
            -->
            <q-space></q-space>

            <#--
            <a :href="currentLinkUrl.replace('/qapps','/vapps')" target="_blank" class="text-warning on-left">BETA PREVIEW<q-tooltip>Click for current production-ready UI (/vapps)</q-tooltip></a>
            -->
            <#-- spinner, usually hidden -->
            <q-circular-progress indeterminate size="20px" color="light-blue" class="q-ma-xs" :class="{ hidden: loading < 1 }"></q-circular-progress>

            <#-- QZ print options placeholder -->
            <component :is="qzVue" ref="qzVue"></component>

            <#-- screen documentation/help -->
            <q-btn dense flat icon="help_outline" color="info" :class="{hidden:!documentMenuList.length}">
                <q-tooltip>${ec.l10n.localize("Documentation")}</q-tooltip>
                <q-menu><q-list dense class="q-my-md">
                    <q-item v-for="screenDoc in documentMenuList" :key="screenDoc.index"><q-item-section>
                        <m-dynamic-dialog :url="currentPath + '/screenDoc?docIndex=' + screenDoc.index" :button-text="screenDoc.title" :title="screenDoc.title"></m-dynamic-dialog>
                    </q-item-section></q-item>
                </q-list></q-menu>
            </q-btn>

            <#-- nav plugins -->
            <template v-for="navPlugin in navPlugins"><component :is="navPlugin"></component></template>

            <#-- notify history -->
            <q-btn dense flat icon="notifications">
                <q-tooltip>${ec.l10n.localize("Notify History")}</q-tooltip>
                <q-menu><q-list dense style="min-width: 300px">
                    <q-item v-for="histItem in notifyHistoryList"><q-item-section>
                        <#-- NOTE: don't use v-html for histItem.message, may contain input repeated back so need to encode for security (make sure scripts not run, etc) -->
                        <q-banner dense rounded class="text-white" :class="'bg-' + getQuasarColor(histItem.type)">
                            <strong>{{histItem.time}}</strong> <span>{{histItem.message}}</span>
                        </q-banner>
                    </q-item-section></q-item>
                </q-list></q-menu>
            </q-btn>

            <#-- screen history menu -->
            <#-- get initial history from server? <#assign screenHistoryList = ec.web.getScreenHistory()><#list screenHistoryList as screenHistory><#if (screenHistory_index >= 25)><#break></#if>{url:pathWithParams, name:title}</#list> -->
            <q-btn dense flat icon="history">
                <q-tooltip>${ec.l10n.localize("Screen History")}</q-tooltip>
                <q-menu><q-list dense style="min-width: 300px">
                    <q-item v-for="histItem in navHistoryList" :key="histItem.pathWithParams" clickable v-close-popup><q-item-section>
                        <m-link :href="histItem.pathWithParams">
                            <template v-if="histItem.image">
                                <i v-if="histItem.imageType === 'icon'" :class="histItem.image" style="padding-right: 8px;"></i>
                                <img v-else :src="histItem.image" :alt="histItem.title" width="18" style="padding-right: 4px;">
                            </template>
                            <i v-else class="fa fa-link" style="padding-right: 8px;"></i>
                            {{histItem.title}}
                        </m-link>
                    </q-item-section></q-item>
                </q-list></q-menu>
            </q-btn>

            <#-- screen history previous screen -->
            <#-- disable this for now to save space, not commonly used and limited value vs browser back:
            <a href="#" @click.prevent="goPreviousScreen()" data-toggle="tooltip" data-original-title="${ec.l10n.localize("Previous Screen")}"
               data-placement="bottom" class="btn btn-default btn-sm navbar-btn navbar-right"><i class="fa fa-chevron-left"></i></a>
            -->

            <q-btn dense flat icon="account_circle">
                <q-tooltip>${(ec.user.userAccount.userFullName)!ec.l10n.localize("Account")}</q-tooltip>
                <q-menu><q-card flat bordered><#-- always matching header (dark): class="${headerClass}" -->
                    <q-card-section horizontal class="q-pa-md">
                        <q-card-section>
                            <#if (ec.user.userAccount.userFullName)?has_content><div class="q-mb-sm text-strong">${ec.l10n.localize("Welcome")} ${ec.user.userAccount.userFullName}</div></#if>

                            <#-- account plugins -->
                            <template v-for="accountPlugin in accountPlugins"><component :is="accountPlugin"></component></template>
                        </q-card-section>
                        <q-separator vertical></q-separator>
                        <q-card-actions vertical class="justify-around q-px-md">
                            <#-- dark/light switch -->
                            <q-btn flat dense @click.prevent="switchDarkLight()" icon="invert_colors">
                                <q-tooltip>${ec.l10n.localize("Switch Dark/Light")}</q-tooltip></q-btn>
                            <#-- logout button -->
                            <q-btn flat dense icon="settings_power" color="negative" type="a" href="${sri.buildUrl("/Login/logout").url}"
                                   onclick="return confirm('${ec.l10n.localize("Logout")} ${(ec.user.userAccount.userFullName)!''}?')">
                                <q-tooltip>${ec.l10n.localize("Logout")} ${(ec.user.userAccount.userFullName)!''}</q-tooltip></q-btn>
                        </q-card-actions>
                    </q-card-section>
                </q-card></q-menu>
            </q-btn>
        </q-toolbar></q-header>

<q-drawer
    v-model="drawer"
    show-if-above
    :mini="!drawer || miniState"
    @click.capture="drawerClick"
    :width="200"
    :breakpoint="500"
    bordered
    content-class="bg-grey-1"
>
    <q-scroll-area class="fit">
        <q-list padding>
            <q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_assignment" />
                </q-item-section>

                <q-item-section>
                    销售订单
                </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item active clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_group" />
                </q-item-section>

                <q-item-section>
                    客户管理
                </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_category" />
                </q-item-section>

                <q-item-section>
                    产品管理
                </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_apartment" />
                </q-item-section>

                <q-item-section>
                    库存管理
                </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_assignment_returned"/>
                </q-item-section>

                <q-item-section>
                    采购管理
                </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_local_offer" />
                </q-item-section>

                <q-item-section>
                    供应商管理
                </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_room_preferences" />
                </q-item-section>

                <q-item-section>
                    生产管理
                </q-item-section>
            </q-item>
            <q-separator></q-separator><q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_account_balance" />
                </q-item-section>

                <q-item-section>
                    财务管理
                </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item clickable v-ripple>
                <q-item-section avatar>
                    <q-icon name="o_settings" />
                </q-item-section>

                <q-item-section>
                    系统管理
                </q-item-section>
            </q-item>
        </q-list>
    </q-scroll-area>

    <!--
      in this case, we use a button (can be anything)
      so that user can switch back
      to mini-mode
    -->
    <div class="q-mini-drawer-hide absolute" style="top: 15px; right: -17px">
        <q-btn
            dense
            round
            unelevated
            color="grey-4"
            text-color="grey"
            icon="chevron_left"
            @click="miniState = true"
        />
    </div>
</q-drawer>

        <q-page-container class="q-ma-sm"><q-page>
            <m-subscreens-active></m-subscreens-active>
        </q-page></q-page-container>

        <q-footer reveal bordered class="text-white row q-pa-xs" id="footer">
            <#assign footerItemList = sri.getThemeValues("STRT_FOOTER_ITEM")>
            <#list footerItemList! as footerItem>
                <#assign footerItemTemplate = footerItem?interpret>
                <@footerItemTemplate/>
            </#list>
        </q-footer>
    </q-layout>
</div>

<script>
    window.quasarConfig = {
        brand: { // this will NOT work on IE 11
            // primary: '#e46262',
            info:'#1e7b8e'
        },
        notify: { progress:true, closeBtn:'X', position:'top-right' }, // default set of options for Notify Quasar plugin
        // loading: {...}, // default set of options for Loading Quasar plugin
        loadingBar: { color:'primary' }, // settings for LoadingBar Quasar plugin
        // ..and many more (check Installation card on each Quasar component/directive/plugin)
    }
</script>