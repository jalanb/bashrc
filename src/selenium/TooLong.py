# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re

class TooLong(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(30)
        self.base_url = "https://www.simplelists.com/"
        self.verificationErrors = []
        self.accept_next_alert = True
    
    def test_too_long(self):
        driver = self.driver
        # open | / | 
        driver.get(self.base_url + "/")
        # click | link=products | 
        driver.find_element_by_link_text("products").click()
        # click | id=button_multiple | 
        driver.find_element_by_id("button_multiple").click()
        # type | id=domain | wwts
        driver.find_element_by_id("domain").clear()
        driver.find_element_by_id("domain").send_keys("wwts")
        # click | name=submit2 | 
        driver.find_element_by_name("submit2").click()
        # click | id=priceplan_payg | 
        driver.find_element_by_id("priceplan_payg").click()
        # click | name=submit3 | 
        driver.find_element_by_name("submit3").click()
        # selectFrame | undefined | 
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | undefined | ]]
        # click | css=div.recaptcha-checkbox-checkmark | 
        driver.find_element_by_css_selector("div.recaptcha-checkbox-checkmark").click()
        # selectWindow | null | 
        # ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
        # type | id=email | gitlab@wwts.com
        driver.find_element_by_id("email").clear()
        driver.find_element_by_id("email").send_keys("gitlab@wwts.com")
        # click | name=terms | 
        driver.find_element_by_name("terms").click()
        # click | name=submit4 | 
        driver.find_element_by_name("submit4").click()
        # click | link=Wwts Slack | 
        driver.find_element_by_link_text("Wwts Slack").click()
        # click | link=Wwts Slack | 
        driver.find_element_by_link_text("Wwts Slack").click()
        # click | css=span.ProfileNav-value | 
        driver.find_element_by_css_selector("span.ProfileNav-value").click()
        # click | css=img.ProfileAvatar-placeholderImage.u-bgUserColor | 
        driver.find_element_by_css_selector("img.ProfileAvatar-placeholderImage.u-bgUserColor").click()
        # click | name=media[] | 
        driver.find_element_by_name("media[]").click()
        # type | name=media[] | /Users/jab/AlanSource/git/wwts/dashboard/static/images/map.png
        driver.find_element_by_name("media[]").clear()
        driver.find_element_by_name("media[]").send_keys("/Users/jab/AlanSource/git/wwts/dashboard/static/images/map.png")
        # click | xpath=(//button[@type='button'])[125] | 
        driver.find_element_by_xpath("(//button[@type='button'])[125]").click()
        # click | css=b | 
        driver.find_element_by_css_selector("b").click()
        # click | id=sgnBt | 
        driver.find_element_by_id("sgnBt").click()
        # click | id=gh-ac | 
        driver.find_element_by_id("gh-ac").click()
        # click | id=gh-ac | 
        driver.find_element_by_id("gh-ac").click()
        # type | id=gh-ac | gmr9600s
        driver.find_element_by_id("gh-ac").clear()
        driver.find_element_by_id("gh-ac").send_keys("gmr9600s")
        # click | id=gh-btn | 
        driver.find_element_by_id("gh-btn").click()
        # click | css=#e1-13 > a.rbx > label > span.rbx | 
        driver.find_element_by_css_selector("#e1-13 > a.rbx > label > span.rbx").click()
        # click | id=e1-12 | 
        driver.find_element_by_id("e1-12").click()
        # click | id=lst-ib | 
        driver.find_element_by_id("lst-ib").click()
        # type | id=lst-ib | gmr9600s
        driver.find_element_by_id("lst-ib").clear()
        driver.find_element_by_id("lst-ib").send_keys("gmr9600s")
        # click | link=Goodmans GMR9600S Main / Stereo Speakers - eBay | 
        driver.find_element_by_link_text("Goodmans GMR9600S Main / Stereo Speakers - eBay").click()
        # click | link=Goodmans GMR9600S Main Stereo Speakers | eBay | 
        driver.find_element_by_link_text("Goodmans GMR9600S Main Stereo Speakers | eBay").click()
        # click | link=Goodmans Official | Premium DAB Radio | Sound Bar | Bluetooth ... | 
        driver.find_element_by_link_text("Goodmans Official | Premium DAB Radio | Sound Bar | Bluetooth ...").click()
        # click | id=subicon8 | 
        driver.find_element_by_id("subicon8").click()
        # click | id=text3 | 
        driver.find_element_by_id("text3").click()
        # click | id=product-addtocart-button | 
        driver.find_element_by_id("product-addtocart-button").click()
        # click | link=Continue Shopping | 
        driver.find_element_by_link_text("Continue Shopping").click()
        # click | link=GOODMANS SHOP | 
        driver.find_element_by_link_text("GOODMANS SHOP").click()
        # click | id=product-collection-image-454 | 
        driver.find_element_by_id("product-collection-image-454").click()
        # click | id=product-collection-image-297 | 
        driver.find_element_by_id("product-collection-image-297").click()
        # click | link=List | 
        driver.find_element_by_link_text("List").click()
        # click | xpath=(//a[contains(text(),'Filter')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'Filter')])[2]").click()
        # click | //div[@id='orders_chosen']/div/ul/li[5] | 
        driver.find_element_by_xpath("//div[@id='orders_chosen']/div/ul/li[5]").click()
        # select | id=orders | label=Price asc.
        Select(driver.find_element_by_id("orders")).select_by_visible_text("Price asc.")
        # click | css=a.button.layered-nav-toggle | 
        driver.find_element_by_css_selector("a.button.layered-nav-toggle").click()
        # click | xpath=(//a[contains(text(),'Filter')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'Filter')])[2]").click()
        # click | //div[@id='limits_chosen']/div/ul/li[3] | 
        driver.find_element_by_xpath("//div[@id='limits_chosen']/div/ul/li[3]").click()
        # select | id=limits | label=36 items per page
        Select(driver.find_element_by_id("limits")).select_by_visible_text("36 items per page")
        # select | id=limits | label=36 items per page
        Select(driver.find_element_by_id("limits")).select_by_visible_text("36 items per page")
        # click | //div[@id='limits_chosen']/div/ul/li[2] | 
        driver.find_element_by_xpath("//div[@id='limits_chosen']/div/ul/li[2]").click()
        # select | id=limits | label=24 items per page
        Select(driver.find_element_by_id("limits")).select_by_visible_text("24 items per page")
        # select | id=limits | label=24 items per page
        Select(driver.find_element_by_id("limits")).select_by_visible_text("24 items per page")
        # select | id=limits | label=24 items per page
        Select(driver.find_element_by_id("limits")).select_by_visible_text("24 items per page")
        # click | link=Next | 
        driver.find_element_by_link_text("Next").click()
        # click | link=Prev | 
        driver.find_element_by_link_text("Prev").click()
        # click | //ul[@id='catalog-listing']/li[8]/div/div[2]/h6/a/span | 
        driver.find_element_by_xpath("//ul[@id='catalog-listing']/li[8]/div/div[2]/h6/a/span").click()
        # click | link=Next | 
        driver.find_element_by_link_text("Next").click()
        # click | link=Next | 
        driver.find_element_by_link_text("Next").click()
        # click | //ul[@id='catalog-listing']/li[11]/div/div[2]/h6/a/span | 
        driver.find_element_by_xpath("//ul[@id='catalog-listing']/li[11]/div/div[2]/h6/a/span").click()
        # click | link=1 | 
        driver.find_element_by_link_text("1").click()
        # click | link=Next | 
        driver.find_element_by_link_text("Next").click()
        # click | link=Next | 
        driver.find_element_by_link_text("Next").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # type | id=twotabsearchtextbox | stereo fm speakers
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("stereo fm speakers")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | potable black stereo fm speakers
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("potable black stereo fm speakers")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | portable black stereo fm speakers
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("portable black stereo fm speakers")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # select | id=sort | label=Price: Low to High
        Select(driver.find_element_by_id("sort")).select_by_visible_text("Price: Low to High")
        # click | //div[@id='refinements']/div[2]/ul/li[2]/ul/li/a/span | 
        driver.find_element_by_xpath("//div[@id='refinements']/div[2]/ul/li[2]/ul/li/a/span").click()
        # click | //ul[@id='ref_340832031']/li/a/span[2] | 
        driver.find_element_by_xpath("//ul[@id='ref_340832031']/li/a/span[2]").click()
        # select | id=sort | label=Price: Low to High
        Select(driver.find_element_by_id("sort")).select_by_visible_text("Price: Low to High")
        # click | link=3 | 
        driver.find_element_by_link_text("3").click()
        # select | id=sort | label=Price: High to Low
        Select(driver.find_element_by_id("sort")).select_by_visible_text("Price: High to Low")
        # click | css=option[value="price-desc-rank"] | 
        driver.find_element_by_css_selector("option[value=\"price-desc-rank\"]").click()
        # click | link=3 | 
        driver.find_element_by_link_text("3").click()
        # click | //li[@id='result_296']/div/div/div/div[2]/div[2]/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_296']/div/div/div/div[2]/div[2]/a/h2").click()
        # click | //li[@id='result_244']/div/div/div/div[2]/div[2]/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_244']/div/div/div/div[2]/div[2]/a/h2").click()
        # click | //li[@id='result_246']/div/div/div/div[2]/div[2]/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_246']/div/div/div/div[2]/div[2]/a/h2").click()
        # click | //li[@id='result_52']/div/div/div/div[2]/div[2]/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_52']/div/div/div/div[2]/div[2]/a/h2").click()
        # click | //div[@id='anonCarousel3']/ol/li[11]/div/a/div[2] | 
        driver.find_element_by_xpath("//div[@id='anonCarousel3']/ol/li[11]/div/a/div[2]").click()
        # click | id=acrCustomerReviewText | 
        driver.find_element_by_id("acrCustomerReviewText").click()
        # click | id=a-autoid-19-announce | 
        driver.find_element_by_id("a-autoid-19-announce").click()
        # click | link=Let us know | 
        driver.find_element_by_link_text("Let us know").click()
        # click | id=a-autoid-18-announce | 
        driver.find_element_by_id("a-autoid-18-announce").click()
        # click | id=add-to-cart-button | 
        driver.find_element_by_id("add-to-cart-button").click()
        # click | id=hlb-view-cart-announce | 
        driver.find_element_by_id("hlb-view-cart-announce").click()
        # click | name=submit.save-for-later.C2EGI9W09X0K6T | 
        driver.find_element_by_name("submit.save-for-later.C2EGI9W09X0K6T").click()
        # click | name=submit.delete.S1W9PK0U4KXCGK | 
        driver.find_element_by_name("submit.delete.S1W9PK0U4KXCGK").click()
        # click | name=submit.delete.S1Q9OL2DEJX74J | 
        driver.find_element_by_name("submit.delete.S1Q9OL2DEJX74J").click()
        # click | name=submit.move-to-cart.SFNKTL8IKQO55 | 
        driver.find_element_by_name("submit.move-to-cart.SFNKTL8IKQO55").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # type | id=twotabsearchtextbox | 80cm cm
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("80cm cm")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # type | id=twotabsearchtextbox | 80cm 
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("80cm")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | 80cm book
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("80cm book")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | name=search | "<3"
        driver.find_element_by_name("search").clear()
        driver.find_element_by_name("search").send_keys("\"<3\"")
        # click | css=button.oo-ui-inputWidget-input.oo-ui-buttonElement-button | 
        driver.find_element_by_css_selector("button.oo-ui-inputWidget-input.oo-ui-buttonElement-button").click()
        # click | link=<3 | 
        driver.find_element_by_link_text("<3").click()
        # type | id=newtab-search-text | "<=2"
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("\"<=2\"")
        # type | id=search_form_input | "<=2" !g
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("\"<=2\" !g")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # click | link=[19] | 
        driver.find_element_by_link_text("[19]").click()
        # click | css=#cite_note-19 > span.reference-text > cite.citation.web > a.external.text | 
        driver.find_element_by_css_selector("#cite_note-19 > span.reference-text > cite.citation.web > a.external.text").click()
        # click | link=OMG! Oxford English Dictionary grows a heart: Graphic symbol for love (and that exclamation) are added as WORDS | 
        driver.find_element_by_link_text("OMG! Oxford English Dictionary grows a heart: Graphic symbol for love (and that exclamation) are added as WORDS").click()
        # click | id=ext-gen99 | 
        driver.find_element_by_id("ext-gen99").click()
        # type | id=lst-ib | oed
        driver.find_element_by_id("lst-ib").clear()
        driver.find_element_by_id("lst-ib").send_keys("oed")
        # click | link=Oxford English Dictionary: Home | 
        driver.find_element_by_link_text("Oxford English Dictionary: Home").click()
        # click | link=Sign in | 
        driver.find_element_by_link_text("Sign in").click()
        # click | link=Close menu | 
        driver.find_element_by_link_text("Close menu").click()
        # click | link=Subscribe | 
        driver.find_element_by_link_text("Subscribe").click()
        # click | link=Customers outside North and South America | 
        driver.find_element_by_link_text("Customers outside North and South America").click()
        # click | link=Customers outside North and South America | 
        driver.find_element_by_link_text("Customers outside North and South America").click()
        # click | link=personal subscription shop | 
        driver.find_element_by_link_text("personal subscription shop").click()
        # click | css=#header_nav > a > img | 
        driver.find_element_by_css_selector("#header_nav > a > img").click()
        # type | id=autoCompleteBox | Ireland
        driver.find_element_by_id("autoCompleteBox").clear()
        driver.find_element_by_id("autoCompleteBox").send_keys("Ireland")
        # click | id=ui-active-menuitem | 
        driver.find_element_by_id("ui-active-menuitem").click()
        # click | id=subscribe_1 | 
        driver.find_element_by_id("subscribe_1").click()
        # click | link=Sign In | 
        driver.find_element_by_link_text("Sign In").click()
        # type | id=ph2_email | social@al-got-rhythm.net
        driver.find_element_by_id("ph2_email").clear()
        driver.find_element_by_id("ph2_email").send_keys("social@al-got-rhythm.net")
        # click | id=ph2_customer_type_new | 
        driver.find_element_by_id("ph2_customer_type_new").click()
        # click | id=ph2_login_or_register | 
        driver.find_element_by_id("ph2_login_or_register").click()
        # click | id=ph2_login_or_register | 
        driver.find_element_by_id("ph2_login_or_register").click()
        # type | id=ph2_password | oup
        driver.find_element_by_id("ph2_password").clear()
        driver.find_element_by_id("ph2_password").send_keys("oup")
        # click | id=ph2_show_password | 
        driver.find_element_by_id("ph2_show_password").click()
        # click | id=ph2_register | 
        driver.find_element_by_id("ph2_register").click()
        # type | id=ph2_password | oup&Bcx4bzrt
        driver.find_element_by_id("ph2_password").clear()
        driver.find_element_by_id("ph2_password").send_keys("oup&Bcx4bzrt")
        # click | id=ph2_register | 
        driver.find_element_by_id("ph2_register").click()
        # click | id=ph2_register | 
        driver.find_element_by_id("ph2_register").click()
        # click | //form[@id='myAccount']/ul/li[2]/a/span | 
        driver.find_element_by_xpath("//form[@id='myAccount']/ul/li[2]/a/span").click()
        # type | id=ph2_title | M
        driver.find_element_by_id("ph2_title").clear()
        driver.find_element_by_id("ph2_title").send_keys("M")
        # click | id=ui-active-menuitem | 
        driver.find_element_by_id("ui-active-menuitem").click()
        # type | id=ph2_first_name | Alan
        driver.find_element_by_id("ph2_first_name").clear()
        driver.find_element_by_id("ph2_first_name").send_keys("Alan")
        # type | id=ph2_middle_initial | J
        driver.find_element_by_id("ph2_middle_initial").clear()
        driver.find_element_by_id("ph2_middle_initial").send_keys("J")
        # type | id=ph2_last_name | Brogan
        driver.find_element_by_id("ph2_last_name").clear()
        driver.find_element_by_id("ph2_last_name").send_keys("Brogan")
        # type | xpath=(//input[@type='text'])[6] | Ireland
        driver.find_element_by_xpath("(//input[@type='text'])[6]").clear()
        driver.find_element_by_xpath("(//input[@type='text'])[6]").send_keys("Ireland")
        # click | id=ui-active-menuitem | 
        driver.find_element_by_id("ui-active-menuitem").click()
        # click | css=input.product_action | 
        driver.find_element_by_css_selector("input.product_action").click()
        # click | css=#emailPreferences > span | 
        driver.find_element_by_css_selector("#emailPreferences > span").click()
        # type | name=password | other&bcx4bzrt
        driver.find_element_by_name("password").clear()
        driver.find_element_by_name("password").send_keys("other&bcx4bzrt")
        # type | name=user_name | other@al-got-rhythm.net
        driver.find_element_by_name("user_name").clear()
        driver.find_element_by_name("user_name").send_keys("other@al-got-rhythm.net")
        # click | //input[@value='Log-In'] | 
        driver.find_element_by_xpath("//input[@value='Log-In']").click()
        # click | css=div.padding.Email_draggable | 
        driver.find_element_by_css_selector("div.padding.Email_draggable").click()
        # click | //div[@id='wm_core_content']/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/table/tbody/tr[2]/td[3]/div/div/div[2]/div/span | 
        driver.find_element_by_xpath("//div[@id='wm_core_content']/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/table/tbody/tr[2]/td[3]/div/div/div[2]/div/span").click()
        # click | //div[@id='wm_core_content']/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/table/tbody/tr[3]/td[3]/div/div[3]/div/div | 
        driver.find_element_by_xpath("//div[@id='wm_core_content']/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/table/tbody/tr[3]/td[3]/div/div[3]/div/div").click()
        # click | css=span > a[title="This external link will open in a new window"] | 
        driver.find_element_by_css_selector("span > a[title=\"This external link will open in a new window\"]").click()
        # click | css=div.subject.items_left > div.Email_draggable | 
        driver.find_element_by_css_selector("div.subject.items_left > div.Email_draggable").click()
        # click | link=Confirm you wish to receive marketing emails from Oxford University Press | 
        driver.find_element_by_link_text("Confirm you wish to receive marketing emails from Oxford University Press").click()
        # click | //div[@id='group-buttons']/a[2]/span/p | 
        driver.find_element_by_xpath("//div[@id='group-buttons']/a[2]/span/p").click()
        # click | //div[@id='group-buttons']/a[6]/span/h3 | 
        driver.find_element_by_xpath("//div[@id='group-buttons']/a[6]/span/h3").click()
        # click | id=topics-Popular-Science | 
        driver.find_element_by_id("topics-Popular-Science").click()
        # click | css=span.topics-header > p | 
        driver.find_element_by_css_selector("span.topics-header > p").click()
        # click | id=topics-Philosophy | 
        driver.find_element_by_id("topics-Philosophy").click()
        # click | //div[@id='arts-and-humanities']/div[2]/div/div[4]/div/label | 
        driver.find_element_by_xpath("//div[@id='arts-and-humanities']/div[2]/div/div[4]/div/label").click()
        # click | id=topics-History | 
        driver.find_element_by_id("topics-History").click()
        # click | //div[@id='arts-and-humanities']/div[2]/div/div[2]/div[2]/label | 
        driver.find_element_by_xpath("//div[@id='arts-and-humanities']/div[2]/div/div[2]/div[2]/label").click()
        # click | id=topics-Linguistics | 
        driver.find_element_by_id("topics-Linguistics").click()
        # click | //div[@id='arts-and-humanities']/div[2]/div/div[2]/div[3]/label | 
        driver.find_element_by_xpath("//div[@id='arts-and-humanities']/div[2]/div/div[2]/div[3]/label").click()
        # click | css=#dictionaries > div.topics-header > h3 | 
        driver.find_element_by_css_selector("#dictionaries > div.topics-header > h3").click()
        # click | //div[@id='group-buttons']/a[2]/span/span[2] | 
        driver.find_element_by_xpath("//div[@id='group-buttons']/a[2]/span/span[2]").click()
        # click | //div[@id='group-buttons']/a[3]/span/span[2] | 
        driver.find_element_by_xpath("//div[@id='group-buttons']/a[3]/span/span[2]").click()
        # click | id=topics-European-Union-Law | 
        driver.find_element_by_id("topics-European-Union-Law").click()
        # click | //div[@id='group-buttons']/a[4]/span/span[2] | 
        driver.find_element_by_xpath("//div[@id='group-buttons']/a[4]/span/span[2]").click()
        # click | id=topics-Psychiatry | 
        driver.find_element_by_id("topics-Psychiatry").click()
        # click | id=topics-Neurology | 
        driver.find_element_by_id("topics-Neurology").click()
        # click | id=topics-Palliative-Medicine | 
        driver.find_element_by_id("topics-Palliative-Medicine").click()
        # click | //div[@id='medicine-and-health']/div[2]/div/div[5]/div[2]/label | 
        driver.find_element_by_xpath("//div[@id='medicine-and-health']/div[2]/div/div[5]/div[2]/label").click()
        # click | //div[@id='group-buttons']/a[5]/span/h3 | 
        driver.find_element_by_xpath("//div[@id='group-buttons']/a[5]/span/h3").click()
        # click | id=topics-Neuroscience | 
        driver.find_element_by_id("topics-Neuroscience").click()
        # click | //div[@id='psychology-and-neuroscience']/div[2]/div/div[3]/div/label | 
        driver.find_element_by_xpath("//div[@id='psychology-and-neuroscience']/div[2]/div/div[3]/div/label").click()
        # click | id=topics-Clinical-Psychology | 
        driver.find_element_by_id("topics-Clinical-Psychology").click()
        # click | //div[@id='psychology-and-neuroscience']/div[2]/div/div/div[2]/label | 
        driver.find_element_by_xpath("//div[@id='psychology-and-neuroscience']/div[2]/div/div/div[2]/label").click()
        # click | id=topics-Music-Psychology | 
        driver.find_element_by_id("topics-Music-Psychology").click()
        # click | //div[@id='psychology-and-neuroscience']/div[2]/div/div[2]/div[2]/label | 
        driver.find_element_by_xpath("//div[@id='psychology-and-neuroscience']/div[2]/div/div[2]/div[2]/label").click()
        # click | id=topics-Cognitive-Psychology | 
        driver.find_element_by_id("topics-Cognitive-Psychology").click()
        # click | //div[@id='psychology-and-neuroscience']/div[2]/div/div/div[3]/label | 
        driver.find_element_by_xpath("//div[@id='psychology-and-neuroscience']/div[2]/div/div/div[3]/label").click()
        # click | id=topics-Music-Psychology | 
        driver.find_element_by_id("topics-Music-Psychology").click()
        # click | //div[@id='psychology-and-neuroscience']/div[2]/div/div[2]/div[2]/label | 
        driver.find_element_by_xpath("//div[@id='psychology-and-neuroscience']/div[2]/div/div[2]/div[2]/label").click()
        # click | id=topics-Clinical-Psychology | 
        driver.find_element_by_id("topics-Clinical-Psychology").click()
        # click | //div[@id='psychology-and-neuroscience']/div[2]/div/div/div[2]/label | 
        driver.find_element_by_xpath("//div[@id='psychology-and-neuroscience']/div[2]/div/div/div[2]/label").click()
        # click | id=topics-Neuropsychology | 
        driver.find_element_by_id("topics-Neuropsychology").click()
        # click | //div[@id='psychology-and-neuroscience']/div[2]/div/div[2]/div[3]/label | 
        driver.find_element_by_xpath("//div[@id='psychology-and-neuroscience']/div[2]/div/div[2]/div[3]/label").click()
        # click | //div[@id='group-buttons']/a[8]/span/h3 | 
        driver.find_element_by_xpath("//div[@id='group-buttons']/a[8]/span/h3").click()
        # click | id=topics-Politics | 
        driver.find_element_by_id("topics-Politics").click()
        # click | //div[@id='social-sciences']/div[2]/div/div[2]/div/label | 
        driver.find_element_by_xpath("//div[@id='social-sciences']/div[2]/div/div[2]/div/label").click()
        # select | id=select_classification | label=General Reader
        Select(driver.find_element_by_id("select_classification")).select_by_visible_text("General Reader")
        # click | id=updateSubmit | 
        driver.find_element_by_id("updateSubmit").click()
        # click | link=English Dictionaries | 
        driver.find_element_by_link_text("English Dictionaries").click()
        # click | css=img[alt="Oxford University Press (OUP)"] | 
        driver.find_element_by_css_selector("img[alt=\"Oxford University Press (OUP)\"]").click()
        # type | name=q | oed
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("oed")
        # click | id=simple_search_submit | 
        driver.find_element_by_id("simple_search_submit").click()
        # click | link=Digital | 
        driver.find_element_by_link_text("Digital").click()
        # select | id=result_sort_ | label=Price: Low-High
        Select(driver.find_element_by_id("result_sort_")).select_by_visible_text("Price: Low-High")
        # select | id=result_selected_page_ | label=Page 64 of 121
        Select(driver.find_element_by_id("result_selected_page_")).select_by_visible_text("Page 64 of 121")
        # select | id=result_selected_page_ | label=Page 32 of 121
        Select(driver.find_element_by_id("result_selected_page_")).select_by_visible_text("Page 32 of 121")
        # type | name=q | stackoverflow
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("stackoverflow")
        # click | css=input[type="submit"] | 
        driver.find_element_by_css_selector("input[type=\"submit\"]").click()
        # click | css=span.selected | 
        driver.find_element_by_css_selector("span.selected").click()
        # click | link=top | 
        driver.find_element_by_link_text("top").click()
        # type | name=q | stackoverflow deleted
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("stackoverflow deleted")
        # click | xpath=(//button[@type='submit'])[2] | 
        driver.find_element_by_xpath("(//button[@type='submit'])[2]").click()
        # type | name=q | 
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("")
        # type | id=search_form_input | stackoverflow 
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("stackoverflow")
        # click | id=search_form_input | 
        driver.find_element_by_id("search_form_input").click()
        # type | id=search_form_input | deleted from stackoverflow 
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("deleted from stackoverflow")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # click | link=stackoverflow | 
        driver.find_element_by_link_text("stackoverflow").click()
        # click | link=top | 
        driver.find_element_by_link_text("top").click()
        # click | css=span.selected | 
        driver.find_element_by_css_selector("span.selected").click()
        # click | link=all time | 
        driver.find_element_by_link_text("all time").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | deleted
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("deleted")
        # click | css=input[type="submit"] | 
        driver.find_element_by_css_selector("input[type=\"submit\"]").click()
        # click | link=Submit a new text post | 
        driver.find_element_by_link_text("Submit a new text post").click()
        # click | link=Submit a new link | 
        driver.find_element_by_link_text("Submit a new link").click()
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # type | id=url | https://apple.stackexchange.com/questions/241829/which-keys-shoot-screens/241830#241830
        driver.find_element_by_id("url").clear()
        driver.find_element_by_id("url").send_keys("https://apple.stackexchange.com/questions/241829/which-keys-shoot-screens/241830#241830")
        # click | css=button[type="button"] | 
        driver.find_element_by_css_selector("button[type=\"button\"]").click()
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | Which keys shoot screens?
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("Which keys shoot screens?")
        # click | id=sendreplies | 
        driver.find_element_by_id("sendreplies").click()
        # click | link=top | 
        driver.find_element_by_link_text("top").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | screenshot
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("screenshot")
        # click | css=input[type="submit"] | 
        driver.find_element_by_css_selector("input[type=\"submit\"]").click()
        # click | //div/div[2]/div/span | 
        driver.find_element_by_xpath("//div/div[2]/div/span").click()
        # click | link=past hour | 
        driver.find_element_by_link_text("past hour").click()
        # click | //div/div[2]/div/span | 
        driver.find_element_by_xpath("//div/div[2]/div/span").click()
        # click | link=past 24 hours | 
        driver.find_element_by_link_text("past 24 hours").click()
        # click | //div/div[2]/div/span | 
        driver.find_element_by_xpath("//div/div[2]/div/span").click()
        # click | link=past week | 
        driver.find_element_by_link_text("past week").click()
        # click | //div/div[2]/div/span | 
        driver.find_element_by_xpath("//div/div[2]/div/span").click()
        # click | link=past month | 
        driver.find_element_by_link_text("past month").click()
        # click | //div/div[2]/div/span | 
        driver.find_element_by_xpath("//div/div[2]/div/span").click()
        # click | link=past year | 
        driver.find_element_by_link_text("past year").click()
        # type | name=q | screenshot keyboard
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("screenshot keyboard")
        # click | //button[@type='submit'] | 
        driver.find_element_by_xpath("//button[@type='submit']").click()
        # click | //div/div[2]/div/span | 
        driver.find_element_by_xpath("//div/div[2]/div/span").click()
        # click | link=all time | 
        driver.find_element_by_link_text("all time").click()
        # type | name=q | 
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("")
        # type | id=search_form_input | screenshot keyboard osx
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("screenshot keyboard osx")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # click | link=How to take a screenshot on your Mac - Apple Support | 
        driver.find_element_by_link_text("How to take a screenshot on your Mac - Apple Support").click()
        # click | id=yes-button | 
        driver.find_element_by_id("yes-button").click()
        # click | css=div.container | 
        driver.find_element_by_css_selector("div.container").click()
        # type | id=interactiveQuestionSearchField | Which keys shoot screens? [duplicate]
        driver.find_element_by_id("interactiveQuestionSearchField").clear()
        driver.find_element_by_id("interactiveQuestionSearchField").send_keys("Which keys shoot screens? [duplicate]")
        # click | css=input.questionSubmitFormButton | 
        driver.find_element_by_css_selector("input.questionSubmitFormButton").click()
        # click | css=input.questionSubmitFormButton | 
        driver.find_element_by_css_selector("input.questionSubmitFormButton").click()
        # type | id=accountname | apple@al-got-rhythm.net
        driver.find_element_by_id("accountname").clear()
        driver.find_element_by_id("accountname").send_keys("apple@al-got-rhythm.net")
        # click | id=signInHyperLink | 
        driver.find_element_by_id("signInHyperLink").click()
        # click | //div[@id='modal-container']/section/ul/li[4]/a/span[2] | 
        driver.find_element_by_xpath("//div[@id='modal-container']/section/ul/li[4]/a/span[2]").click()
        # click | id=link-post-241830 | 
        driver.find_element_by_id("link-post-241830").click()
        # type | css=div.share-tip > input[type="text"] | 
        driver.find_element_by_css_selector("div.share-tip > input[type=\"text\"]").clear()
        driver.find_element_by_css_selector("div.share-tip > input[type=\"text\"]").send_keys("")
        # click | css=span.jive-category-wrap > label | 
        driver.find_element_by_css_selector("span.jive-category-wrap > label").click()
        # click | id=j-category_1786 | 
        driver.find_element_by_id("j-category_1786").click()
        # select | id=product | label=MacBook
        Select(driver.find_element_by_id("product")).select_by_visible_text("MacBook")
        # select | id=operatingSystems | label=OS X El Capitan (10.11)
        Select(driver.find_element_by_id("operatingSystems")).select_by_visible_text("OS X El Capitan (10.11)")
        # click | id=j-category_1804 | 
        driver.find_element_by_id("j-category_1804").click()
        # click | //div[@id='jive-compose-categories']/div[18]/span/label | 
        driver.find_element_by_xpath("//div[@id='jive-compose-categories']/div[18]/span/label").click()
        # click | id=j-category_1791 | 
        driver.find_element_by_id("j-category_1791").click()
        # click | //div[@id='jive-compose-categories']/div[6]/span/label | 
        driver.find_element_by_xpath("//div[@id='jive-compose-categories']/div[6]/span/label").click()
        # click | id=submitButton | 
        driver.find_element_by_id("submitButton").click()
        # click | id=link-post-241830 | 
        driver.find_element_by_id("link-post-241830").click()
        # click | css=span.text | 
        driver.find_element_by_css_selector("span.text").click()
        # click | xpath=(//button[@type='submit'])[2] | 
        driver.find_element_by_xpath("(//button[@type='submit'])[2]").click()
        # click | xpath=(//button[@type='submit'])[2] | 
        driver.find_element_by_xpath("(//button[@type='submit'])[2]").click()
        # type | name=session[password] | twitter&bcx4bzrt
        driver.find_element_by_name("session[password]").clear()
        driver.find_element_by_name("session[password]").send_keys("twitter&bcx4bzrt")
        # type | name=session[username_or_email] | al_got_rhythm
        driver.find_element_by_name("session[username_or_email]").clear()
        driver.find_element_by_name("session[username_or_email]").send_keys("al_got_rhythm")
        # click | //input[@value='Log in'] | 
        driver.find_element_by_xpath("//input[@value='Log in']").click()
        # type | id=newtab-search-text | twitter as a service
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("twitter as a service")
        # type | id=newtab-search-text | python twitter
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("python twitter")
        # click | link=twitter 1.17.1 : Python Package Index | 
        driver.find_element_by_link_text("twitter 1.17.1 : Python Package Index").click()
        # click | //ul[@id='channel-list']/li/a/span[3]/span | 
        driver.find_element_by_xpath("//ul[@id='channel-list']/li/a/span[3]/span").click()
        # click | //img[contains(@src,'https://files.slack.com/files-tmb/T033R7BD9-F1F6MQ1TL-f79e91fd6c/screen_shot_2016-06-08_at_17.37.52_720.png')] | 
        driver.find_element_by_xpath("//img[contains(@src,'https://files.slack.com/files-tmb/T033R7BD9-F1F6MQ1TL-f79e91fd6c/screen_shot_2016-06-08_at_17.37.52_720.png')]").click()
        # type | id=typeahead-algolia-template | paint shop pro
        driver.find_element_by_id("typeahead-algolia-template").clear()
        driver.find_element_by_id("typeahead-algolia-template").send_keys("paint shop pro")
        # click | css=button.btn.btn-primary | 
        driver.find_element_by_css_selector("button.btn.btn-primary").click()
        # type | id=typeahead-algolia-template | gimp
        driver.find_element_by_id("typeahead-algolia-template").clear()
        driver.find_element_by_id("typeahead-algolia-template").send_keys("gimp")
        # click | css=button.btn.btn-primary | 
        driver.find_element_by_css_selector("button.btn.btn-primary").click()
        # click | css=span.platform-filter | 
        driver.find_element_by_css_selector("span.platform-filter").click()
        # click | css=a[title="Mac OS X alternatives to GIMP"] > span.usage | 
        driver.find_element_by_css_selector("a[title=\"Mac OS X alternatives to GIMP\"] > span.usage").click()
        # click | css=span.license-filter | 
        driver.find_element_by_css_selector("span.license-filter").click()
        # click | link=Free or Open Source25 | 
        driver.find_element_by_link_text("Free or Open Source25").click()
        # click | link=Krita | 
        driver.find_element_by_link_text("Krita").click()
        # click | link=Official Website | 
        driver.find_element_by_link_text("Official Website").click()
        # click | link=Download | 
        driver.find_element_by_link_text("Download").click()
        # click | link=Download the latest OSX binary. | 
        driver.find_element_by_link_text("Download the latest OSX binary.").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # click | link=hot | 
        driver.find_element_by_link_text("hot").click()
        # click | link=hot | 
        driver.find_element_by_link_text("hot").click()
        # click | link=hot | 
        driver.find_element_by_link_text("hot").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # click | link=month | 
        driver.find_element_by_link_text("month").click()
        # click | link=active | 
        driver.find_element_by_link_text("active").click()
        # click | id=nav-unanswered | 
        driver.find_element_by_id("nav-unanswered").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | record key strokes
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("record key strokes")
        # type | id=newtab-search-text | record key strokes osx
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("record key strokes osx")
        # type | id=search_form_input | record key strokes osx !g
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("record key strokes osx !g")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # click | css=i | 
        driver.find_element_by_css_selector("i").click()
        # click | link=exact:Recording keystrokes and mouse clicks? | Apple Support Communities | 
        driver.find_element_by_link_text("Recording keystrokes and mouse clicks? | Apple Support Communities").click()
        # click | css=section > div.jive-rendered-content | 
        driver.find_element_by_css_selector("section > div.jive-rendered-content").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | the document automater.app could not be opened
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("the document automater.app could not be opened")
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | the document  could not be opened
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("the document  could not be opened")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | link=Downloads | 
        driver.find_element_by_link_text("Downloads").click()
        # click | link=iTerm2 3.0.1 beta (OS 10.8+) | 
        driver.find_element_by_link_text("iTerm2 3.0.1 beta (OS 10.8+)").click()
        # click | css=ul.right > li > a > img | 
        driver.find_element_by_css_selector("ul.right > li > a > img").click()
        # click | link=Dean Martin - "Ain't That a Kick in the Head" (Lyrics) | 
        driver.find_element_by_link_text("Dean Martin - \"Ain't That a Kick in the Head\" (Lyrics)").click()
        # click | css=button.ytp-play-button.ytp-button | 
        driver.find_element_by_css_selector("button.ytp-play-button.ytp-button").click()
        # click | id=ul-btn | 
        driver.find_element_by_id("ul-btn").click()
        # type | id=twotabsearchtextbox | airport nat caddy hd ssd
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("airport nat caddy hd ssd")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # type | id=twotabsearchtextbox | airport 
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("airport")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # click | //div[@id='refinements']/div[2]/ul/li/ul/li[2]/a/span | 
        driver.find_element_by_xpath("//div[@id='refinements']/div[2]/ul/li/ul/li[2]/a/span").click()
        # click | //div[@id='refinements']/div[2]/ul/li/ul/li[3]/a/span | 
        driver.find_element_by_xpath("//div[@id='refinements']/div[2]/ul/li/ul/li[3]/a/span").click()
        # click | //ul[@id='ref_187137031']/li[5]/a | 
        driver.find_element_by_xpath("//ul[@id='ref_187137031']/li[5]/a").click()
        # click | id=sort | 
        driver.find_element_by_id("sort").click()
        # select | id=sort | label=Newest Arrivals
        Select(driver.find_element_by_id("sort")).select_by_visible_text("Newest Arrivals")
        # type | id=twotabsearchtextbox | nas
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("nas")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | nas caddy
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("nas caddy")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # click | css=span.refinementLink.seeMore | 
        driver.find_element_by_css_selector("span.refinementLink.seeMore").click()
        # click | css=span.childRefinementLink | 
        driver.find_element_by_css_selector("span.childRefinementLink").click()
        # click | id=sort | 
        driver.find_element_by_id("sort").click()
        # select | id=sort | label=Price: Low to High
        Select(driver.find_element_by_id("sort")).select_by_visible_text("Price: Low to High")
        # click | //li[@id='result_0']/div/div[3]/div/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_0']/div/div[3]/div/a/h2").click()
        # click | id=revSAFRLU | 
        driver.find_element_by_id("revSAFRLU").click()
        # click | link=5 star | 
        driver.find_element_by_link_text("5 star").click()
        # click | id=a-autoid-20-announce | 
        driver.find_element_by_id("a-autoid-20-announce").click()
        # click | id=seeMoreDetailsLink | 
        driver.find_element_by_id("seeMoreDetailsLink").click()
        # click | //div[@id='ra-0']/div/h2/a/b[2] | 
        driver.find_element_by_xpath("//div[@id='ra-0']/div/h2/a/b[2]").click()
        # click | id=proceedTemporary | 
        driver.find_element_by_id("proceedTemporary").click()
        # click | //div[@id='r1-0']/div/h2/a/b | 
        driver.find_element_by_xpath("//div[@id='r1-0']/div/h2/a/b").click()
        # click | //div[@id='r1-1']/div/h2/a/b | 
        driver.find_element_by_xpath("//div[@id='r1-1']/div/h2/a/b").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # type | id=twotabsearchtextbox | external hdd caddy
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external hdd caddy")
        # click | //li[@id='result_0']/div/div[3]/div/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_0']/div/div[3]/div/a/h2").click()
        # type | id=twotabsearchtextbox | external hdd docking
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external hdd docking")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # type | id=twotabsearchtextbox | external  docking
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external  docking")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # select | id=sort | label=Price: Low to High
        Select(driver.find_element_by_id("sort")).select_by_visible_text("Price: Low to High")
        # click | css=span.refinementLink | 
        driver.find_element_by_css_selector("span.refinementLink").click()
        # type | id=low-price | 15
        driver.find_element_by_id("low-price").clear()
        driver.find_element_by_id("low-price").send_keys("15")
        # click | css=input.leftNavGoBtn | 
        driver.find_element_by_css_selector("input.leftNavGoBtn").click()
        # click | //li[@id='result_16']/div/div[3]/div/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_16']/div/div[3]/div/a/h2").click()
        # type | id=low-price | 31
        driver.find_element_by_id("low-price").clear()
        driver.find_element_by_id("low-price").send_keys("31")
        # click | css=input.leftNavGoBtn | 
        driver.find_element_by_css_selector("input.leftNavGoBtn").click()
        # type | id=twotabsearchtextbox | external  docking "8 bays"
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external  docking \"8 bays\"")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | external  docking "4 bays"
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external  docking \"4 bays\"")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | external  docking "2 bays"
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external  docking \"2 bays\"")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | external  docking "4 bays"
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external  docking \"4 bays\"")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # type | id=twotabsearchtextbox | external  docking "6 bays"
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("external  docking \"6 bays\"")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # click | //li[@id='result_0']/div/div[3]/div/a/h2 | 
        driver.find_element_by_xpath("//li[@id='result_0']/div/div[3]/div/a/h2").click()
        # click | css=a.a-link-normal.askATFLink > span.a-size-base | 
        driver.find_element_by_css_selector("a.a-link-normal.askATFLink > span.a-size-base").click()
        # click | link=See more answered questions (2) | 
        driver.find_element_by_link_text("See more answered questions (2)").click()
        # click | id=gh-ac | 
        driver.find_element_by_id("gh-ac").click()
        # type | id=gh-ac | 4-bay sata
        driver.find_element_by_id("gh-ac").clear()
        driver.find_element_by_id("gh-ac").send_keys("4-bay sata")
        # click | id=gh-btn | 
        driver.find_element_by_id("gh-btn").click()
        # click | id=gh-ac | 
        driver.find_element_by_id("gh-ac").click()
        # type | id=gh-ac | 4-bay sata orico
        driver.find_element_by_id("gh-ac").clear()
        driver.find_element_by_id("gh-ac").send_keys("4-bay sata orico")
        # click | id=gh-btn | 
        driver.find_element_by_id("gh-btn").click()
        # click | //a[contains(text(),'Buy it now')] | 
        driver.find_element_by_xpath("//a[contains(text(),'Buy it now')]").click()
        # type | id=amount | 70
        driver.find_element_by_id("amount").clear()
        driver.find_element_by_id("amount").send_keys("70")
        # click | id=from_sc | 
        driver.find_element_by_id("from_sc").click()
        # click | css=li.ac_odd.ac_recent | 
        driver.find_element_by_css_selector("li.ac_odd.ac_recent").click()
        # click | LOCATOR_DETECTION_FAILED | 
        # ERROR: Caught exception [Error: locator strategy either id or name must be specified explicitly.]
        # click | link=exact:Price: lowest first | 
        driver.find_element_by_link_text("Price: lowest first").click()
        # click | link=Price + P&P: lowest first | 
        driver.find_element_by_link_text("Price + P&P: lowest first").click()
        # click | link=ORICO 4 Bay 2.5"/ 3.5" USB 3.0 SATA HDD Hard Drive Docking Station with Clone | 
        driver.find_element_by_link_text("ORICO 4 Bay 2.5\"/ 3.5\" USB 3.0 SATA HDD Hard Drive Docking Station with Clone").click()
        # click | id=to | 
        driver.find_element_by_id("to").click()
        # click | css=li.ac_odd.ac_recent | 
        driver.find_element_by_css_selector("li.ac_odd.ac_recent").click()
        # click | LOCATOR_DETECTION_FAILED | 
        # ERROR: Caught exception [Error: locator strategy either id or name must be specified explicitly.]
        # click | id=add-to-cart-button | 
        driver.find_element_by_id("add-to-cart-button").click()
        # click | id=hlb-view-cart-announce | 
        driver.find_element_by_id("hlb-view-cart-announce").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | sms
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("sms")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | sms android
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("sms android")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | messages
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("messages")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | link=exact:A: Which OS X Applications do you find indispensable? | 
        driver.find_element_by_link_text("A: Which OS X Applications do you find indispensable?").click()
        # click | link=exact:Q: How does iMessage know that the recipient is an iOS 5 device? | 
        driver.find_element_by_link_text("Q: How does iMessage know that the recipient is an iOS 5 device?").click()
        # click | link=imessage | 
        driver.find_element_by_link_text("imessage").click()
        # type | id=typeahead-algolia-template | imessage
        driver.find_element_by_id("typeahead-algolia-template").clear()
        driver.find_element_by_id("typeahead-algolia-template").send_keys("imessage")
        # click | css=button.btn.btn-primary | 
        driver.find_element_by_css_selector("button.btn.btn-primary").click()
        # click | css=span.platform-filter | 
        driver.find_element_by_css_selector("span.platform-filter").click()
        # click | link=Mac15 | 
        driver.find_element_by_link_text("Mac15").click()
        # click | css=span.platform-filter | 
        driver.find_element_by_css_selector("span.platform-filter").click()
        # click | link=Android21 | 
        driver.find_element_by_link_text("Android21").click()
        # type | id=typeahead-algolia-template | sms
        driver.find_element_by_id("typeahead-algolia-template").clear()
        driver.find_element_by_id("typeahead-algolia-template").send_keys("sms")
        # click | css=button.btn.btn-primary | 
        driver.find_element_by_css_selector("button.btn.btn-primary").click()
        # click | css=span.platform-filter | 
        driver.find_element_by_css_selector("span.platform-filter").click()
        # click | link=Android293 | 
        driver.find_element_by_link_text("Android293").click()
        # click | css=span.license-filter | 
        driver.find_element_by_css_selector("span.license-filter").click()
        # click | link=Only Open Source15 | 
        driver.find_element_by_link_text("Only Open Source15").click()
        # type | id=typeahead-algolia-template | nomachine
        driver.find_element_by_id("typeahead-algolia-template").clear()
        driver.find_element_by_id("typeahead-algolia-template").send_keys("nomachine")
        # click | css=button.btn.btn-primary | 
        driver.find_element_by_css_selector("button.btn.btn-primary").click()
        # click | css=i.icon-down-open | 
        driver.find_element_by_css_selector("i.icon-down-open").click()
        # click | link=Android10 | 
        driver.find_element_by_link_text("Android10").click()
        # click | css=span.license-filter | 
        driver.find_element_by_css_selector("span.license-filter").click()
        # click | link=Free or Open Source6 | 
        driver.find_element_by_link_text("Free or Open Source6").click()
        # click | id=twotabsearchtextbox | 
        driver.find_element_by_id("twotabsearchtextbox").click()
        # type | id=twotabsearchtextbox | microphones
        driver.find_element_by_id("twotabsearchtextbox").clear()
        driver.find_element_by_id("twotabsearchtextbox").send_keys("microphones")
        # click | css=input.nav-input | 
        driver.find_element_by_css_selector("input.nav-input").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | webcam
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("webcam")
        # click | link=webcam | 
        driver.find_element_by_link_text("webcam").click()
        # type | id=newtab-search-text | isight api
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("isight api")
        # type | id=search_form_input | isight android
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("isight android")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # type | id=search_form_input | isight android osx
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("isight android osx")
        # click | //div[@id='r1-0']/div/h2/a/b[2] | 
        driver.find_element_by_xpath("//div[@id='r1-0']/div/h2/a/b[2]").click()
        # type | id=search_form_input | realvnc android
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("realvnc android")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # type | name=q | realvnc
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("realvnc")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | link=vnc | 
        driver.find_element_by_link_text("vnc").click()
        # click | link=exact:I want to remotely control my Android device from my PC without rooting it. Is this possible? | 
        driver.find_element_by_link_text("I want to remotely control my Android device from my PC without rooting it. Is this possible?").click()
        # click | link=up vote | 
        driver.find_element_by_link_text("up vote").click()
        # click | link=its | 
        driver.find_element_by_link_text("its").click()
        # click | link=TeamViewer | 
        driver.find_element_by_link_text("TeamViewer").click()
        # click | css=#nav-tile-mac > a > img | 
        driver.find_element_by_css_selector("#nav-tile-mac > a > img").click()
        # click | css=#nav-tile-mac > a > img | 
        driver.find_element_by_css_selector("#nav-tile-mac > a > img").click()
        # click | link=Download TeamViewer | 
        driver.find_element_by_link_text("Download TeamViewer").click()
        # type | id=newtab-search-text | create vm sparsebundle
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("create vm sparsebundle")
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | vm sparsebundle
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("vm sparsebundle")
        # click | link=exact:Q: Can I create a bootable VM from a Mac sparsebundle using symbolic links? | 
        driver.find_element_by_link_text("Q: Can I create a bootable VM from a Mac sparsebundle using symbolic links?").click()
        # click | link=up vote | 
        driver.find_element_by_link_text("up vote").click()
        # click | link=vmware | 
        driver.find_element_by_link_text("vmware").click()
        # click | link=Restore timemachine sparsebundle to virtualbox | Apple ... | 
        driver.find_element_by_link_text("Restore timemachine sparsebundle to virtualbox | Apple ...").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | rename group
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("rename group")
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | create group
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("create group")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | bash
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("bash")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | [bash] create group
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("[bash] create group")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # type | id=newtab-search-text | bash rename group
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("bash rename group")
        # type | id=search_form_input | bash rename group !g
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("bash rename group !g")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # type | id=lst-ib | bash "rename group"
        driver.find_element_by_id("lst-ib").clear()
        driver.find_element_by_id("lst-ib").send_keys("bash \"rename group\"")
        # type | id=lst-ib | bash "rename group" -files
        driver.find_element_by_id("lst-ib").clear()
        driver.find_element_by_id("lst-ib").send_keys("bash \"rename group\" -files")
        # type | name=q | rename group
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("rename group")
        # click | link=exact:Q: Rename user's group name | 
        driver.find_element_by_link_text("Q: Rename user's group name").click()
        # click | link=up vote | 
        driver.find_element_by_link_text("up vote").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | groupmod
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("groupmod")
        # type | id=newtab-search-text | !g groupmod osx
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("!g groupmod osx")
        # click | link=linux - What is the mMac equivalent to groupmod - Super User | 
        driver.find_element_by_link_text("linux - What is the mMac equivalent to groupmod - Super User").click()
        # click | link=up vote | 
        driver.find_element_by_link_text("up vote").click()
        # click | css=#answer-1059375 > table > tbody > tr > td.votecell > div.vote > a.vote-up-off | 
        driver.find_element_by_css_selector("#answer-1059375 > table > tbody > tr > td.votecell > div.vote > a.vote-up-off").click()
        # type | name=q | new group
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("new group")
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | new group 
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("new group")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | "new group"
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("\"new group\"")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("")
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | "new group"
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("\"new group\"")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "create group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"create group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | "create group"
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("\"create group\"")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # type | css=td.col1 > input[name="q"] | "create group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"create group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | "create group"
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("\"create group\"")
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | link=exact:A: Create new user group in Mac OS | 
        driver.find_element_by_link_text("A: Create new user group in Mac OS").click()
        # click | link=exact:http://serverfault.com/questions/131942/how-do-i-add-a-group-in-mac-os-x-10-6 | 
        driver.find_element_by_link_text("http://serverfault.com/questions/131942/how-do-i-add-a-group-in-mac-os-x-10-6").click()
        # click | css=td.answercell > div.post-text > pre > code | 
        driver.find_element_by_css_selector("td.answercell > div.post-text > pre > code").click()
        # type | name=q | add user group
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("add user group")
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | add user group osx
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("add user group osx")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | add user group 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("add user group")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "add user group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"add user group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "add user to group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"add user to group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("")
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "add user to group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"add user to group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "add user to group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"add user to group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "add user to group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"add user to group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # type | name=q | "add user to group"
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("\"add user to group\"")
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "add user to group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"add user to group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | "add user to group"
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("\"add user to group\"")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | link=exact:Q: Add user to group which can access network interfaces | 
        driver.find_element_by_link_text("Q: Add user to group which can access network interfaces").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | link=votes | 
        driver.find_element_by_link_text("votes").click()
        # click | css=code | 
        driver.find_element_by_css_selector("code").click()
        # click | css=td.col1 > input[name="q"] | 
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").click()
        # type | css=td.col1 > input[name="q"] | gpasswd
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").clear()
        driver.find_element_by_css_selector("td.col1 > input[name=\"q\"]").send_keys("gpasswd")
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # click | css=td.col2 > input[type="submit"] | 
        driver.find_element_by_css_selector("td.col2 > input[type=\"submit\"]").click()
        # type | id=newtab-search-text | gpasswd osx
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("gpasswd osx")
        # click | link=Managing Users - Running Mac OS X Tiger [Book] | 
        driver.find_element_by_link_text("Managing Users - Running Mac OS X Tiger [Book]").click()
        # type | id=search_form_input | gpasswd osx !g
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("gpasswd osx !g")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # click | link=osx snow leopard - Is there a usermod equivalent in terminal for OS X ... | 
        driver.find_element_by_link_text("osx snow leopard - Is there a usermod equivalent in terminal for OS X ...").click()
        # click | link=up vote | 
        driver.find_element_by_link_text("up vote").click()
        # click | css=#answer-60169 > table > tbody > tr > td.votecell > div.vote > a.vote-up-off | 
        driver.find_element_by_css_selector("#answer-60169 > table > tbody > tr > td.votecell > div.vote > a.vote-up-off").click()
        # click | link=dscl manpage | 
        driver.find_element_by_link_text("dscl manpage").click()
        # click | id=header-bottom-left | 
        driver.find_element_by_id("header-bottom-left").click()
        # click | link=2896 | 
        driver.find_element_by_link_text("2896").click()
        # click | xpath=(//a[contains(text(),'permalink')])[298] | 
        driver.find_element_by_xpath("(//a[contains(text(),'permalink')])[298]").click()
        # click | link=permalink | 
        driver.find_element_by_link_text("permalink").click()
        # click | link=jalanb | 
        driver.find_element_by_link_text("jalanb").click()
        # click | link=comments | 
        driver.find_element_by_link_text("comments").click()
        # click | css=div.dropdown.lightdrop > span.selected | 
        driver.find_element_by_css_selector("div.dropdown.lightdrop > span.selected").click()
        # click | link=top | 
        driver.find_element_by_link_text("top").click()
        # click | css=ul.flat-list.buttons | 
        driver.find_element_by_css_selector("ul.flat-list.buttons").click()
        # click | //form[@id='form-t1_cb9n73zox4']/div | 
        driver.find_element_by_xpath("//form[@id='form-t1_cb9n73zox4']/div").click()
        # click | xpath=(//a[contains(text(),'context')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[10]").click()
        # click | css=#thing_t1_c0504ce > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink | 
        driver.find_element_by_css_selector("#thing_t1_c0504ce > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | css=div.md > p | 
        driver.find_element_by_css_selector("div.md > p").click()
        # click | link=permalink | 
        driver.find_element_by_link_text("permalink").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.cancel | 
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.cancel").click()
        # click | css=button.cancel | 
        driver.find_element_by_css_selector("button.cancel").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.cancel | 
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.cancel").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # type | name=text | [42](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)

        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("[42](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # type | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name="text"] | [42](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("[42](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name="text"] | [4]()[2](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("[4]()[2](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)")
        # click | link=permalink | 
        driver.find_element_by_link_text("permalink").click()
        # click | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name="text"] | [4](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)[2](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("[4](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)[2](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)")
        # click | css=#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#form-t1_d3sabpabq3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=4 | 
        driver.find_element_by_link_text("4").click()
        # type | id=newtab-search-text | xkcd 42
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("xkcd 42")
        # click | //div[@id='r1-0']/div/h2/a/b[3] | 
        driver.find_element_by_xpath("//div[@id='r1-0']/div/h2/a/b[3]").click()
        # click | link=exact:http://shortminds.com/2008/08/11/explaining-greatnes/ | 
        driver.find_element_by_link_text("http://shortminds.com/2008/08/11/explaining-greatnes/").click()
        # click | link=exact:42: Geico - explain xkcd | 
        driver.find_element_by_link_text("42: Geico - explain xkcd").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | [4](http://explainxkcd.com/wiki/index.php/42:_Geico)[2](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)

        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("[4](http://explainxkcd.com/wiki/index.php/42:_Geico)[2](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | css=#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name="text"] | [4](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)[2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)
        driver.find_element_by_css_selector("#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("[4](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)[2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)")
        # click | css=#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#form-t1_d3sabpal4v > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=4 | 
        driver.find_element_by_link_text("4").click()
        # click | id=thing_t1_c0504ce | 
        driver.find_element_by_id("thing_t1_c0504ce").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | id=thing_t1_d3sabpa | 
        driver.find_element_by_id("thing_t1_d3sabpa").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | id=thing_t1_d3sabpa | 
        driver.find_element_by_id("thing_t1_d3sabpa").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | id=sr-autocomplete | 
        driver.find_element_by_id("sr-autocomplete").click()
        # type | id=sr-autocomplete | redditthoughts
        driver.find_element_by_id("sr-autocomplete").clear()
        driver.find_element_by_id("sr-autocomplete").send_keys("redditthoughts")
        # click | link=curated by /u/jalanb | 
        driver.find_element_by_link_text("curated by /u/jalanb").click()
        # click | link=/r/redditthoughts | 
        driver.find_element_by_link_text("/r/redditthoughts").click()
        # click | link=Submit a new link | 
        driver.find_element_by_link_text("Submit a new link").click()
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | A bifurcating 42
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("A bifurcating 42")
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # type | id=url | https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce
        driver.find_element_by_id("url").clear()
        driver.find_element_by_id("url").send_keys("https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce")
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | Link from 42 7 years ago back to last week
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("Link from 42 7 years ago back to last week")
        # click | name=submit | 
        driver.find_element_by_name("submit").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | link=comment | 
        driver.find_element_by_link_text("comment").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'no')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'no')])[3]").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[3]").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | link=Submit a new link | 
        driver.find_element_by_link_text("Submit a new link").click()
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | Re-linking an old 42 back into the current stream
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("Re-linking an old 42 back into the current stream")
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # type | id=url | https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce
        driver.find_element_by_id("url").clear()
        driver.find_element_by_id("url").send_keys("https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce")
        # click | id=newlink | 
        driver.find_element_by_id("newlink").click()
        # click | name=submit | 
        driver.find_element_by_name("submit").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | Half the link goes to either 
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("Half the link goes to either")
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | The 4s link to either Wikipedia or Geico:42

        # The 2s travel time
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("The 4s link to either Wikipedia or Geico:42\n\nThe 2s travel time")
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | The 4s link to either Wikipedia or Geico:42

        # The [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel time
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("The 4s link to either Wikipedia or Geico:42\n\nThe [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel time")
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | The 4s link to either Wikipedia or Geico:42

        # The [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("The 4s link to either Wikipedia or Geico:42\n\nThe [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | css=#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name="text"] | The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or Geico:42

        # The [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)
        driver.find_element_by_css_selector("#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or Geico:42\n\nThe [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | css=#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name="text"] | The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)

        # The [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)
        driver.find_element_by_css_selector("#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)\n\nThe [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | css=#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#form-t1_d41r6c97vg > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | link=Submit a new text post | 
        driver.find_element_by_link_text("Submit a new text post").click()
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | Relinking 7 years ago back into 7 days ago
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("Relinking 7 years ago back into 7 days ago")
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | css=#form-t1_d41r6c9fpp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d41r6c9fpp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#form-t1_d41r6c9fpp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d41r6c9fpp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d41r6c9fpp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("")
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)

        # The [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)\n\nThe [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | name=submit | 
        driver.find_element_by_name("submit").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[3]").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | link=comment | 
        driver.find_element_by_link_text("comment").click()
        # click | link=Relinking 7 years ago back into 7 days ago | 
        driver.find_element_by_link_text("Relinking 7 years ago back into 7 days ago").click()
        # click | id=header-img | 
        driver.find_element_by_id("header-img").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | 42
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("42")
        # click | css=input[type="submit"] | 
        driver.find_element_by_css_selector("input[type=\"submit\"]").click()
        # click | //header/div/div[2]/div/span | 
        driver.find_element_by_xpath("//header/div/div[2]/div/span").click()
        # click | link=past hour | 
        driver.find_element_by_link_text("past hour").click()
        # click | //div[@id='previoussearch']/div[3] | 
        driver.find_element_by_xpath("//div[@id='previoussearch']/div[3]").click()
        # click | css=div.dropdown.lightdrop > span.selected | 
        driver.find_element_by_css_selector("div.dropdown.lightdrop > span.selected").click()
        # click | link=new | 
        driver.find_element_by_link_text("new").click()
        # click | link=refine | 
        driver.find_element_by_link_text("refine").click()
        # click | //div[@id='previoussearch']/div/dl/dt[5] | 
        driver.find_element_by_xpath("//div[@id='previoussearch']/div/dl/dt[5]").click()
        # click | //div[@id='previoussearch']/div/dl/dt[5] | 
        driver.find_element_by_xpath("//div[@id='previoussearch']/div/dl/dt[5]").click()
        # click | //div[@id='previoussearch']/div/dl/dt[5] | 
        driver.find_element_by_xpath("//div[@id='previoussearch']/div/dl/dt[5]").click()
        # click | //div[@id='previoussearch']/div/dl/dt[5] | 
        driver.find_element_by_xpath("//div[@id='previoussearch']/div/dl/dt[5]").click()
        # type | name=q | selftext:42
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("selftext:42")
        # click | //button[@type='submit'] | 
        driver.find_element_by_xpath("//button[@type='submit']").click()
        # click | //div[5]/div/div[3]/span | 
        driver.find_element_by_xpath("//div[5]/div/div[3]/span").click()
        # click | css=div.RES-keyNav-activeElement > div.search-result-meta > a.search-comments.may-blank | 
        driver.find_element_by_css_selector("div.RES-keyNav-activeElement > div.search-result-meta > a.search-comments.may-blank").click()
        # click | css=div.markdownEditor-wrapper | 
        driver.find_element_by_css_selector("div.markdownEditor-wrapper").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[2] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[2]").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | Both [4]()[2]()s have been noted
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("Both [4]()[2]()s have been noted")
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | Both [4](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)[2]()s have been noted
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("Both [4](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)[2]()s have been noted")
        # click | link=4 | 
        driver.find_element_by_link_text("4").click()
        # click | link=time | 
        driver.find_element_by_link_text("time").click()
        # click | link=perma-link | 
        driver.find_element_by_link_text("perma-link").click()
        # type | name=text | 
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("")
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[5] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[5]").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | [Both](/s "42") [4](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)[2](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)s [have been redditted](/s "42")
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("[Both](/s \"42\") [4](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)[2](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)s [have been redditted](/s \"42\")")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | xpath=(//a[contains(text(),'DenverCoder9')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'DenverCoder9')])[3]").click()
        # click | xpath=(//a[contains(text(),'delete')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[2]").click()
        # click | xpath=(//a[contains(text(),'yes')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[4]").click()
        # click | xpath=(//a[contains(text(),'delete')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[2]").click()
        # click | xpath=(//a[contains(text(),'yes')])[5] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[5]").click()
        # click | id=header-img | 
        driver.find_element_by_id("header-img").click()
        # click | LOCATOR_DETECTION_FAILED | 
        # ERROR: Caught exception [Error: locator strategy either id or name must be specified explicitly.]
        # click | id=mail | 
        driver.find_element_by_id("mail").click()
        # click | link=context | 
        driver.find_element_by_link_text("context").click()
        # click | css=#thing_t1_czwaa7b > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required | 
        driver.find_element_by_css_selector("#thing_t1_czwaa7b > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required").click()
        # click | css=#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | link=permalink | 
        driver.find_element_by_link_text("permalink").click()
        # click | link=permalink | 
        driver.find_element_by_link_text("permalink").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | css=li.accountName | 
        driver.find_element_by_css_selector("li.accountName").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | 
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("")
        # click | css=button.cancel | 
        driver.find_element_by_css_selector("button.cancel").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | link=Relinking 7 years ago back into 7 days ago | 
        driver.find_element_by_link_text("Relinking 7 years ago back into 7 days ago").click()
        # click | link=Submit a new text post | 
        driver.find_element_by_link_text("Submit a new text post").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[5] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[5]").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)

        # The [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("The 4s link to either [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) or [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)\n\nThe [2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)s travel [time](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # click | link=comment | 
        driver.find_element_by_link_text("comment").click()
        # click | css=p.title | 
        driver.find_element_by_css_selector("p.title").click()
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | Relinking 7 years ago back into 7 days ago
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("Relinking 7 years ago back into 7 days ago")
        # click | name=captcha | 
        driver.find_element_by_name("captcha").click()
        # type | name=captcha | RCHNMJ
        driver.find_element_by_name("captcha").clear()
        driver.find_element_by_name("captcha").send_keys("RCHNMJ")
        # click | name=submit | 
        driver.find_element_by_name("submit").click()
        # click | css=#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#thing_t1_czw84gx > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink | 
        driver.find_element_by_css_selector("#thing_t1_czw84gx > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink").click()
        # click | link=reply | 
        driver.find_element_by_link_text("reply").click()
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | SORRY, THINK I was muted.
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("SORRY, THINK I was muted.")
        # click | link=337 comments | 
        driver.find_element_by_link_text("337 comments").click()
        # click | //div[@id='thing_t3_458pm4']/a/img | 
        driver.find_element_by_xpath("//div[@id='thing_t3_458pm4']/a/img").click()
        # click | link=exact:http://www.mirrorsoferis.com/forum/thread05232003a.html | 
        driver.find_element_by_link_text("http://www.mirrorsoferis.com/forum/thread05232003a.html").click()
        # click | link=view the rest of the comments | 
        driver.find_element_by_link_text("view the rest of the comments").click()
        # click | id=form-t3_458pm4iv8 | 
        driver.find_element_by_id("form-t3_458pm4iv8").click()
        # click | css=#thing_t1_czwaa7b > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required | 
        driver.find_element_by_css_selector("#thing_t1_czwaa7b > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required").click()
        # type | css=#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name="text"] | One doesn't wake an account like this very often, but I made a funny: 
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("One doesn't wake an account like this very often, but I made a funny:")
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | xpath=(//a[contains(text(),'comment')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'comment')])[4]").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | css=li.accountName | 
        driver.find_element_by_css_selector("li.accountName").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[3]").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | link=comment | 
        driver.find_element_by_link_text("comment").click()
        # click | css=#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_czwaa7b > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("")
        # click | css=#thing_t1_czw84gx > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required | 
        driver.find_element_by_css_selector("#thing_t1_czw84gx > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required").click()
        # click | xpath=(//a[contains(text(),'reply')])[112] | 
        driver.find_element_by_xpath("(//a[contains(text(),'reply')])[112]").click()
        # click | xpath=(//a[contains(text(),'reply')])[112] | 
        driver.find_element_by_xpath("(//a[contains(text(),'reply')])[112]").click()
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)


        # Thanks for calling. 

        # Back to sleep for another few years now
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)\n\n\nThanks for calling. \n\nBack to sleep for another few years now")
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[5] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[5]").click()
        # click | link=reply | 
        driver.find_element_by_link_text("reply").click()
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name="text"] | I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)


        # Thanks for calling. 

        # Back to sleep for another few years now
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)\n\n\nThanks for calling. \n\nBack to sleep for another few years now")
        # click | css=#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#commentreply_t1_czw84gx > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | id=mail | 
        driver.find_element_by_id("mail").click()
        # click | xpath=(//a[contains(text(),'context')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[2]").click()
        # click | //form[@id='form-t1_czonddne45']/div | 
        driver.find_element_by_xpath("//form[@id='form-t1_czonddne45']/div").click()
        # click | //form[@id='form-t1_czonefi5ml']/div/div/p | 
        driver.find_element_by_xpath("//form[@id='form-t1_czonefi5ml']/div/div/p").click()
        # click | //form[@id='form-t1_czonefi5ml']/div/div | 
        driver.find_element_by_xpath("//form[@id='form-t1_czonefi5ml']/div/div").click()
        # click | css=#thing_t1_czonddn > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required | 
        driver.find_element_by_css_selector("#thing_t1_czonddn > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required").click()
        # click | css=#commentreply_t1_czonddn > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_czonddn > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_czonddn > div.usertext-edit.md-container > div.md > textarea[name="text"] | I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)


        # Thanks for calling. 

        # Back to sleep for another few years now
        driver.find_element_by_css_selector("#commentreply_t1_czonddn > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_czonddn > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)\n\n\nThanks for calling. \n\nBack to sleep for another few years now")
        # click | css=#commentreply_t1_czonddn > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#commentreply_t1_czonddn > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | xpath=(//a[contains(text(),'context')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[3]").click()
        # click | css=#thing_t1_cz8evi2 > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required | 
        driver.find_element_by_css_selector("#thing_t1_cz8evi2 > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required").click()
        # click | css=#commentreply_t1_cz8evi2 > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_cz8evi2 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_cz8evi2 > div.usertext-edit.md-container > div.md > textarea[name="text"] | I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)


        # Thanks for calling. 

        # Back to sleep for another few years now
        driver.find_element_by_css_selector("#commentreply_t1_cz8evi2 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_cz8evi2 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)\n\n\nThanks for calling. \n\nBack to sleep for another few years now")
        # click | css=#commentreply_t1_cz8evi2 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#commentreply_t1_cz8evi2 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | xpath=(//a[contains(text(),'context')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[4]").click()
        # click | css=#thing_t1_cyo28w3 > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink | 
        driver.find_element_by_css_selector("#thing_t1_cyo28w3 > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink").click()
        # click | link=reply | 
        driver.find_element_by_link_text("reply").click()
        # click | css=#commentreply_t1_cyo28w3 > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_cyo28w3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_cyo28w3 > div.usertext-edit.md-container > div.md > textarea[name="text"] | I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)


        # Thanks for calling. 

        # Back to sleep for another few years now
        driver.find_element_by_css_selector("#commentreply_t1_cyo28w3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_cyo28w3 > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)\n\n\nThanks for calling. \n\nBack to sleep for another few years now")
        # click | css=#commentreply_t1_cyo28w3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#commentreply_t1_cyo28w3 > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | css=#thing_t1_cyo7dgj > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required | 
        driver.find_element_by_css_selector("#thing_t1_cyo7dgj > div.entry.unvoted > ul.flat-list.buttons > li.reply-button > a.access-required").click()
        # click | css=#commentreply_t1_cyo7dgj > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#commentreply_t1_cyo7dgj > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#commentreply_t1_cyo7dgj > div.usertext-edit.md-container > div.md > textarea[name="text"] | I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)


        # Thanks for calling. 

        # Back to sleep for another few years now
        driver.find_element_by_css_selector("#commentreply_t1_cyo7dgj > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#commentreply_t1_cyo7dgj > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("I found [this](https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/)\n\n\nThanks for calling. \n\nBack to sleep for another few years now")
        # click | css=#commentreply_t1_cyo7dgj > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#commentreply_t1_cyo7dgj > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | xpath=(//a[contains(text(),'context')])[5] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[5]").click()
        # click | css=#thing_t1_cyo47tl > div.entry.unvoted > p.tagline > a.expand | 
        driver.find_element_by_css_selector("#thing_t1_cyo47tl > div.entry.unvoted > p.tagline > a.expand").click()
        # click | xpath=(//a[contains(text(),'context')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[6]").click()
        # click | LOCATOR_DETECTION_FAILED | 
        # ERROR: Caught exception [Error: locator strategy either id or name must be specified explicitly.]
        # click | css=#thing_t1_cvsxhw2 > div.entry.unvoted | 
        driver.find_element_by_css_selector("#thing_t1_cvsxhw2 > div.entry.unvoted").click()
        # click | xpath=(//a[contains(text(),'permalink')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'permalink')])[3]").click()
        # click | link=flashbunnny | 
        driver.find_element_by_link_text("flashbunnny").click()
        # click | link=send a private message | 
        driver.find_element_by_link_text("send a private message").click()
        # type | id=quickMessageDialogSubject | You 
        driver.find_element_by_id("quickMessageDialogSubject").clear()
        driver.find_element_by_id("quickMessageDialogSubject").send_keys("You")
        # click | id=quickMessageDialogClose | 
        driver.find_element_by_id("quickMessageDialogClose").click()
        # click | link=send a private message | 
        driver.find_element_by_link_text("send a private message").click()
        # type | id=quickMessageDialogSubject | I saw this
        driver.find_element_by_id("quickMessageDialogSubject").clear()
        driver.find_element_by_id("quickMessageDialogSubject").send_keys("I saw this")
        # type | id=quickMessageDialogBody | 
        driver.find_element_by_id("quickMessageDialogBody").clear()
        driver.find_element_by_id("quickMessageDialogBody").send_keys("")
        # type | id=quickMessageDialogBody | https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/
        driver.find_element_by_id("quickMessageDialogBody").clear()
        driver.find_element_by_id("quickMessageDialogBody").send_keys("https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/")
        # click | id=quickMessageDialogSend | 
        driver.find_element_by_id("quickMessageDialogSend").click()
        # click | link=open full message form | 
        driver.find_element_by_link_text("open full message form").click()
        # click | name=captcha | 
        driver.find_element_by_name("captcha").click()
        # type | name=captcha | CXORBN
        driver.find_element_by_name("captcha").clear()
        driver.find_element_by_name("captcha").send_keys("CXORBN")
        # click | id=send | 
        driver.find_element_by_id("send").click()
        # type | name=captcha | QFXVTS
        driver.find_element_by_name("captcha").clear()
        driver.find_element_by_name("captcha").send_keys("QFXVTS")
        # click | id=send | 
        driver.find_element_by_id("send").click()
        # click | link=DenverCoder9 | 
        driver.find_element_by_link_text("DenverCoder9").click()
        # click | link=comments | 
        driver.find_element_by_link_text("comments").click()
        # click | id=mail | 
        driver.find_element_by_id("mail").click()
        # click | //div[@id='thing_t1_czonefi']/div[2]/p | 
        driver.find_element_by_xpath("//div[@id='thing_t1_czonefi']/div[2]/p").click()
        # click | xpath=(//a[contains(text(),'context')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[2]").click()
        # click | xpath=(//a[contains(text(),'context')])[8] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[8]").click()
        # click | link=leaderoftheinnercirc | 
        driver.find_element_by_link_text("leaderoftheinnercirc").click()
        # click | link=send message | 
        driver.find_element_by_link_text("send message").click()
        # type | id=quickMessageDialogSubject | I FOUND THIS
        driver.find_element_by_id("quickMessageDialogSubject").clear()
        driver.find_element_by_id("quickMessageDialogSubject").send_keys("I FOUND THIS")
        # type | id=quickMessageDialogBody | https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/
        driver.find_element_by_id("quickMessageDialogBody").clear()
        driver.find_element_by_id("quickMessageDialogBody").send_keys("https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/")
        # click | id=quickMessageDialogSend | 
        driver.find_element_by_id("quickMessageDialogSend").click()
        # click | css=div.RESNotificationClose.RESCloseButton | 
        driver.find_element_by_css_selector("div.RESNotificationClose.RESCloseButton").click()
        # click | id=quickMessageDialogClose | 
        driver.find_element_by_id("quickMessageDialogClose").click()
        # click | link=DenverCoder9 | 
        driver.find_element_by_link_text("DenverCoder9").click()
        # click | link=preferences | 
        driver.find_element_by_link_text("preferences").click()
        # click | link=password/email | 
        driver.find_element_by_link_text("password/email").click()
        # type | name=curpass | reddit&bcx4bzrt
        driver.find_element_by_name("curpass").clear()
        driver.find_element_by_name("curpass").send_keys("reddit&bcx4bzrt")
        # type | css=#pref-update-password > div.spacer > div.roundfield. > div.roundfield-content > input[name="curpass"] | reddit&bcx4bzrt
        driver.find_element_by_css_selector("#pref-update-password > div.spacer > div.roundfield. > div.roundfield-content > input[name=\"curpass\"]").clear()
        driver.find_element_by_css_selector("#pref-update-password > div.spacer > div.roundfield. > div.roundfield-content > input[name=\"curpass\"]").send_keys("reddit&bcx4bzrt")
        # type | name=email | social@al-got-rhythm.net
        driver.find_element_by_name("email").clear()
        driver.find_element_by_name("email").send_keys("social@al-got-rhythm.net")
        # click | css=button.btn | 
        driver.find_element_by_css_selector("button.btn").click()
        # type | name=curpass | bcx
        driver.find_element_by_name("curpass").clear()
        driver.find_element_by_name("curpass").send_keys("bcx")
        # type | css=#pref-update-password > div.spacer > div.roundfield. > div.roundfield-content > input[name="curpass"] | 
        driver.find_element_by_css_selector("#pref-update-password > div.spacer > div.roundfield. > div.roundfield-content > input[name=\"curpass\"]").clear()
        driver.find_element_by_css_selector("#pref-update-password > div.spacer > div.roundfield. > div.roundfield-content > input[name=\"curpass\"]").send_keys("")
        # click | css=button.btn | 
        driver.find_element_by_css_selector("button.btn").click()
        # type | name=password | other&bcx4bzrt
        driver.find_element_by_name("password").clear()
        driver.find_element_by_name("password").send_keys("other&bcx4bzrt")
        # type | name=user_name | other@al-got-rhythm.net
        driver.find_element_by_name("user_name").clear()
        driver.find_element_by_name("user_name").send_keys("other@al-got-rhythm.net")
        # click | //input[@value='Log-In'] | 
        driver.find_element_by_xpath("//input[@value='Log-In']").click()
        # type | id=newtab-search-text | web front end for email
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("web front end for email")
        # type | id=search_form_input | web front end for email -gmail -outlook
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("web front end for email -gmail -outlook")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # click | //div[@id='r1-7']/div/h2/a/b | 
        driver.find_element_by_xpath("//div[@id='r1-7']/div/h2/a/b").click()
        # type | id=search_form_input | "web front end for email" -gmail -outlook
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("\"web front end for email\" -gmail -outlook")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # type | id=search_form_input | "web UI for email" -gmail -outlook
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("\"web UI for email\" -gmail -outlook")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # type | id=search_form_input | "web UI for email" -gmail -outlook !g
        driver.find_element_by_id("search_form_input").clear()
        driver.find_element_by_id("search_form_input").send_keys("\"web UI for email\" -gmail -outlook !g")
        # click | id=search_button | 
        driver.find_element_by_id("search_button").click()
        # type | id=lst-ib | "web frontend for email" -gmail -outlook
        driver.find_element_by_id("lst-ib").clear()
        driver.find_element_by_id("lst-ib").send_keys("\"web frontend for email\" -gmail -outlook")
        # type | id=lst-ib | "web front end for email" -gmail -outlook
        driver.find_element_by_id("lst-ib").clear()
        driver.find_element_by_id("lst-ib").send_keys("\"web front end for email\" -gmail -outlook")
        # click | link=Web Mail Software - xmail@xmailserver.org | 
        driver.find_element_by_link_text("Web Mail Software - xmail@xmailserver.org").click()
        # click | css=#post2 > div.post_body.parsed | 
        driver.find_element_by_css_selector("#post2 > div.post_body.parsed").click()
        # type | id=typeahead-algolia-template | xmailserver
        driver.find_element_by_id("typeahead-algolia-template").clear()
        driver.find_element_by_id("typeahead-algolia-template").send_keys("xmailserver")
        # click | css=button.btn.btn-primary | 
        driver.find_element_by_css_selector("button.btn.btn-primary").click()
        # click | css=span.license-filter | 
        driver.find_element_by_css_selector("span.license-filter").click()
        # click | link=Mac1 | 
        driver.find_element_by_link_text("Mac1").click()
        # click | link=Zarafa | 
        driver.find_element_by_link_text("Zarafa").click()
        # click | css=#showAllInfo > span | 
        driver.find_element_by_css_selector("#showAllInfo > span").click()
        # click | //form[@id='mainform']/section/div/div[4]/div/div/a[2]/span | 
        driver.find_element_by_xpath("//form[@id='mainform']/section/div/div[4]/div/div/a[2]/span").click()
        # click | css=span.platform-filter | 
        driver.find_element_by_css_selector("span.platform-filter").click()
        # click | link=Linux9 | 
        driver.find_element_by_link_text("Linux9").click()
        # click | link=iRedMail | 
        driver.find_element_by_link_text("iRedMail").click()
        # click | link=1 | 
        driver.find_element_by_link_text("1").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | link=AndYourLittleDogToo | 
        driver.find_element_by_link_text("AndYourLittleDogToo").click()
        # click | link=comments | 
        driver.find_element_by_link_text("comments").click()
        # click | xpath=(//a[contains(text(),'delete')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[3]").click()
        # click | xpath=(//a[contains(text(),'yes')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[6]").click()
        # click | xpath=(//a[contains(text(),'delete')])[9] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[9]").click()
        # click | xpath=(//a[contains(text(),'yes')])[19] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[19]").click()
        # click | xpath=(//a[contains(text(),'delete')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[4]").click()
        # click | xpath=(//a[contains(text(),'yes')])[9] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[9]").click()
        # click | xpath=(//a[contains(text(),'delete')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[2]").click()
        # click | xpath=(//a[contains(text(),'yes')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[4]").click()
        # click | link=overview | 
        driver.find_element_by_link_text("overview").click()
        # click | id=header-img | 
        driver.find_element_by_id("header-img").click()
        # click | name=q | 
        driver.find_element_by_name("q").click()
        # type | name=q | my friend
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("my friend")
        # click | css=input[type="submit"] | 
        driver.find_element_by_css_selector("input[type=\"submit\"]").click()
        # click | link=/r/HELLO_MY_FRIEND | 
        driver.find_element_by_link_text("/r/HELLO_MY_FRIEND").click()
        # click | //header/div/div[2]/div/span | 
        driver.find_element_by_xpath("//header/div/div[2]/div/span").click()
        # click | link=past hour | 
        driver.find_element_by_link_text("past hour").click()
        # click | id=header-img | 
        driver.find_element_by_id("header-img").click()
        # click | link=My Subreddits | 
        driver.find_element_by_link_text("My Subreddits").click()
        # click | id=header-bottom-left | 
        driver.find_element_by_id("header-bottom-left").click()
        # click | link=Submit a new link | 
        driver.find_element_by_link_text("Submit a new link").click()
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | So, "my friend" spotted a ripple in Reddit history
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("So, \"my friend\" spotted a ripple in Reddit history")
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # click | id=sr-autocomplete | 
        driver.find_element_by_id("sr-autocomplete").click()
        # type | id=sr-autocomplete | bestof
        driver.find_element_by_id("sr-autocomplete").clear()
        driver.find_element_by_id("sr-autocomplete").send_keys("bestof")
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # click | link=comment | 
        driver.find_element_by_link_text("comment").click()
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # type | id=url | https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/
        driver.find_element_by_id("url").clear()
        driver.find_element_by_id("url").send_keys("https://www.reddit.com/r/redditthoughts/comments/4n8qy5/relinking_7_years_ago_back_into_7_days_ago/")
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | My friend spotted a ripple in Reddit history
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("My friend spotted a ripple in Reddit history")
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # type | id=url | https://www.reddit.com/r/redditthoughts/
        driver.find_element_by_id("url").clear()
        driver.find_element_by_id("url").send_keys("https://www.reddit.com/r/redditthoughts/")
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | css=div.RESNotificationClose.RESCloseButton | 
        driver.find_element_by_css_selector("div.RESNotificationClose.RESCloseButton").click()
        # click | link=logout | 
        driver.find_element_by_link_text("logout").click()
        # type | id=user_reg | jalanb
        driver.find_element_by_id("user_reg").clear()
        driver.find_element_by_id("user_reg").send_keys("jalanb")
        # type | id=passwd_reg | reddit&bcx4bzrt
        driver.find_element_by_id("passwd_reg").clear()
        driver.find_element_by_id("passwd_reg").send_keys("reddit&bcx4bzrt")
        # type | id=passwd_login | reddit&bcx4bzrt
        driver.find_element_by_id("passwd_login").clear()
        driver.find_element_by_id("passwd_login").send_keys("reddit&bcx4bzrt")
        # type | id=user_login | jalanb
        driver.find_element_by_id("user_login").clear()
        driver.find_element_by_id("user_login").send_keys("jalanb")
        # click | xpath=(//button[@type='submit'])[2] | 
        driver.find_element_by_xpath("(//button[@type='submit'])[2]").click()
        # click | link=comment | 
        driver.find_element_by_link_text("comment").click()
        # type | name=user | jalanb
        driver.find_element_by_name("user").clear()
        driver.find_element_by_name("user").send_keys("jalanb")
        # type | name=passwd | reddit&bcx4bzrt
        driver.find_element_by_name("passwd").clear()
        driver.find_element_by_name("passwd").send_keys("reddit&bcx4bzrt")
        # click | link=time | 
        driver.find_element_by_link_text("time").click()
        # type | name=user | jalanb
        driver.find_element_by_name("user").clear()
        driver.find_element_by_name("user").send_keys("jalanb")
        # type | name=passwd | reddit&bcx4bzrt
        driver.find_element_by_name("passwd").clear()
        driver.find_element_by_name("passwd").send_keys("reddit&bcx4bzrt")
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # type | name=user | jalanb
        driver.find_element_by_name("user").clear()
        driver.find_element_by_name("user").send_keys("jalanb")
        # type | name=passwd | reddit&bcx4bzrt
        driver.find_element_by_name("passwd").clear()
        driver.find_element_by_name("passwd").send_keys("reddit&bcx4bzrt")
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # type | name=user | jalanb
        driver.find_element_by_name("user").clear()
        driver.find_element_by_name("user").send_keys("jalanb")
        # type | name=passwd | reddit&bcx4bzrt
        driver.find_element_by_name("passwd").clear()
        driver.find_element_by_name("passwd").send_keys("reddit&bcx4bzrt")
        # click | //div[@id='thing_t1_d3satia']/div/div[2] | 
        driver.find_element_by_xpath("//div[@id='thing_t1_d3satia']/div/div[2]").click()
        # click | xpath=(//button[@type='submit'])[3] | 
        driver.find_element_by_xpath("(//button[@type='submit'])[3]").click()
        # click | id=showPasswords | 
        driver.find_element_by_id("showPasswords").click()
        # selectFrame | dialogFrame | 
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | dialogFrame | ]]
        # click | id=togglePasswords | 
        driver.find_element_by_id("togglePasswords").click()
        # selectWindow | null | 
        # ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
        # click | css=span.emphasize | 
        driver.find_element_by_css_selector("span.emphasize").click()
        # click | name=session[username_or_email] | 
        driver.find_element_by_name("session[username_or_email]").click()
        # type | name=session[password] | twitter&bcx4bzrt
        driver.find_element_by_name("session[password]").clear()
        driver.find_element_by_name("session[password]").send_keys("twitter&bcx4bzrt")
        # type | name=session[username_or_email] | al_got_rhythm
        driver.find_element_by_name("session[username_or_email]").clear()
        driver.find_element_by_name("session[username_or_email]").send_keys("al_got_rhythm")
        # click | //input[@value='Log in'] | 
        driver.find_element_by_xpath("//input[@value='Log in']").click()
        # click | id=global-new-tweet-button | 
        driver.find_element_by_id("global-new-tweet-button").click()
        # click | id=typeahead-item-2 | 
        driver.find_element_by_id("typeahead-item-2").click()
        # type | css=textarea.RichEditor-tempTextArea | My other friend found a riple in the history of #reddit 
        driver.find_element_by_css_selector("textarea.RichEditor-tempTextArea").clear()
        driver.find_element_by_css_selector("textarea.RichEditor-tempTextArea").send_keys("My other friend found a riple in the history of #reddit")
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # click | name=title | 
        driver.find_element_by_name("title").click()
        # type | name=title | His friend spotted a ripple in Reddit history
        driver.find_element_by_name("title").clear()
        driver.find_element_by_name("title").send_keys("His friend spotted a ripple in Reddit history")
        # click | id=url | 
        driver.find_element_by_id("url").click()
        # type | name=user | jalanb
        driver.find_element_by_name("user").clear()
        driver.find_element_by_name("user").send_keys("jalanb")
        # type | name=passwd | reddit&bcx4bzrt
        driver.find_element_by_name("passwd").clear()
        driver.find_element_by_name("passwd").send_keys("reddit&bcx4bzrt")
        # click | css=button.btn | 
        driver.find_element_by_css_selector("button.btn").click()
        # click | css=button.btn | 
        driver.find_element_by_css_selector("button.btn").click()
        # click | link=jalanb | 
        driver.find_element_by_link_text("jalanb").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[2]").click()
        # click | xpath=(//a[contains(text(),'2')])[5] | 
        driver.find_element_by_xpath("(//a[contains(text(),'2')])[5]").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | id=thing_t1_d3sabpa | 
        driver.find_element_by_id("thing_t1_d3sabpa").click()
        # click | //form[@id='form-t1_d3sabpacbp']/div/div/p | 
        driver.find_element_by_xpath("//form[@id='form-t1_d3sabpacbp']/div/div/p").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=4 | 
        driver.find_element_by_link_text("4").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | css=button.cancel | 
        driver.find_element_by_css_selector("button.cancel").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=edit | 
        driver.find_element_by_link_text("edit").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").click()
        # type | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name="text"] | [4](http://explainxkcd.com/wiki/index.php/42:_Geico)[2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").clear()
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.md > textarea[name=\"text\"]").send_keys("[4](http://explainxkcd.com/wiki/index.php/42:_Geico)[2](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce)")
        # click | css=#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save | 
        driver.find_element_by_css_selector("#form-t1_d3sabpacbp > div.usertext-edit.md-container > div.bottom-area > div.usertext-buttons > button.save").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | [4](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)[2](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)

        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("[4](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything)[2](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | link=4 | 
        driver.find_element_by_link_text("4").click()
        # click | link=exact:http://www.google.com/search?q=the+answer+to+life%2C+the+universe%2C+and+everything | 
        driver.find_element_by_link_text("http://www.google.com/search?q=the+answer+to+life%2C+the+universe%2C+and+everything").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=2 | 
        driver.find_element_by_link_text("2").click()
        # click | link=comment | 
        driver.find_element_by_link_text("comment").click()
        # click | //form[@id='form-t3_4n8qy56m9']/div/div/p[2] | 
        driver.find_element_by_xpath("//form[@id='form-t3_4n8qy56m9']/div/div/p[2]").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[5] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[5]").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | Split links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything), [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico) and [time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travel](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("Split links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything), [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico) and [time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travel](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | [time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travelling](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa) links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything), [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("[time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travelling](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa) links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything), [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | [Time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travelling](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa) links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything), [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("[Time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travelling](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa) links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything), [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | [Time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travelling](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa) links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) and [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("[Time](https://www.reddit.com/r/comics/comments/6vrpb/explaining_xkcd_greatness/c0504ce) [travelling](https://www.reddit.com/r/UNU/comments/4m3n49/what_is_the_ultimate_answer_to_life_the_universe/d3sabpa) links to [Wikipedia](http://en.wikipedia.org/wiki/Answer_to_Life%2C_the_Universe%2C_and_Everything) and [Geico:42](http://explainxkcd.com/wiki/index.php/42:_Geico)")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | xpath=(//a[contains(text(),'Relinking 7 years ago back into 7 days ago')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'Relinking 7 years ago back into 7 days ago')])[2]").click()
        # click | link=redditthoughts | 
        driver.find_element_by_link_text("redditthoughts").click()
        # click | link=Reddit has a nonny mouse | 
        driver.find_element_by_link_text("Reddit has a nonny mouse").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | css=li.accountName | 
        driver.find_element_by_css_selector("li.accountName").click()
        # click | link=subreddit settings | 
        driver.find_element_by_link_text("subreddit settings").click()
        # click | link=subreddit settings | 
        driver.find_element_by_link_text("subreddit settings").click()
        # click | id=type_restricted | 
        driver.find_element_by_id("type_restricted").click()
        # click | id=wikimode_disabled | 
        driver.find_element_by_id("wikimode_disabled").click()
        # click | id=spam_comments_high | 
        driver.find_element_by_id("spam_comments_high").click()
        # click | id=spam_comments_all | 
        driver.find_element_by_id("spam_comments_all").click()
        # click | id=spam_selfposts_all | 
        driver.find_element_by_id("spam_selfposts_all").click()
        # click | //div[@id='sr-form']/div[10]/div/div/ul/li[3]/label | 
        driver.find_element_by_xpath("//div[@id='sr-form']/div[10]/div/div/ul/li[3]/label").click()
        # click | id=show_media | 
        driver.find_element_by_id("show_media").click()
        # click | xpath=(//input[@name='key_color'])[18] | 
        driver.find_element_by_xpath("(//input[@name='key_color'])[18]").click()
        # click | name=edit | 
        driver.find_element_by_name("edit").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[2] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[2]").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[6] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[6]").click()
        # click | link=jab-fun | 
        driver.find_element_by_link_text("jab-fun").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | link=yes | 
        driver.find_element_by_link_text("yes").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[4]").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[4]").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[6]").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | xpath=(//a[contains(text(),'yes')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[7]").click()
        # click | xpath=(//a[contains(text(),'delete')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[2]").click()
        # click | xpath=(//a[contains(text(),'yes')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[10]").click()
        # click | xpath=(//a[contains(text(),'delete')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[4]").click()
        # click | xpath=(//a[contains(text(),'yes')])[14] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[14]").click()
        # click | xpath=(//a[contains(text(),'context')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[6]").click()
        # click | //form[@id='form-t1_c1u475ckop']/div/div/p/a[2] | 
        driver.find_element_by_xpath("//form[@id='form-t1_c1u475ckop']/div/div/p/a[2]").click()
        # click | xpath=(//a[contains(text(),'delete')])[5] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[5]").click()
        # click | xpath=(//a[contains(text(),'yes')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[10]").click()
        # click | xpath=(//a[contains(text(),'delete')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[6]").click()
        # click | xpath=(//a[contains(text(),'yes')])[12] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[12]").click()
        # click | xpath=(//a[contains(text(),'delete')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[6]").click()
        # click | xpath=(//a[contains(text(),'yes')])[14] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[14]").click()
        # click | xpath=(//a[contains(text(),'delete')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[6]").click()
        # click | xpath=(//a[contains(text(),'yes')])[16] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[16]").click()
        # click | xpath=(//a[contains(text(),'delete')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[7]").click()
        # click | xpath=(//a[contains(text(),'yes')])[19] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[19]").click()
        # click | xpath=(//a[contains(text(),'delete')])[8] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[8]").click()
        # click | xpath=(//a[contains(text(),'yes')])[22] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[22]").click()
        # click | xpath=(//a[contains(text(),'delete')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[10]").click()
        # click | xpath=(//a[contains(text(),'yes')])[27] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[27]").click()
        # click | xpath=(//a[contains(text(),'delete')])[11] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[11]").click()
        # click | xpath=(//a[contains(text(),'yes')])[30] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[30]").click()
        # click | xpath=(//a[contains(text(),'delete')])[11] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[11]").click()
        # click | xpath=(//a[contains(text(),'yes')])[31] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[31]").click()
        # click | xpath=(//a[contains(text(),'This one ended well')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'This one ended well')])[2]").click()
        # click | //form[@id='form-t1_c09jfzgl1z']/div/div/p/a[2] | 
        driver.find_element_by_xpath("//form[@id='form-t1_c09jfzgl1z']/div/div/p/a[2]").click()
        # click | //form[@id='form-t1_c09jfzgl1z']/div/div/p/div/div/audio | 
        driver.find_element_by_xpath("//form[@id='form-t1_c09jfzgl1z']/div/div/p/div/div/audio").click()
        # click | xpath=(//a[contains(text(),'delete')])[14] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[14]").click()
        # click | xpath=(//a[contains(text(),'yes')])[29] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[29]").click()
        # click | xpath=(//a[contains(text(),'delete')])[13] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[13]").click()
        # click | xpath=(//a[contains(text(),'yes')])[27] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[27]").click()
        # click | xpath=(//a[contains(text(),'delete')])[14] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[14]").click()
        # click | xpath=(//a[contains(text(),'no')])[33] | 
        driver.find_element_by_xpath("(//a[contains(text(),'no')])[33]").click()
        # click | xpath=(//a[contains(text(),'delete')])[16] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[16]").click()
        # click | xpath=(//a[contains(text(),'yes')])[35] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[35]").click()
        # click | xpath=(//a[contains(text(),'delete')])[16] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[16]").click()
        # click | xpath=(//a[contains(text(),'yes')])[36] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[36]").click()
        # click | xpath=(//a[contains(text(),'delete')])[16] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[16]").click()
        # click | xpath=(//a[contains(text(),'yes')])[37] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[37]").click()
        # click | xpath=(//a[contains(text(),'delete')])[16] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[16]").click()
        # click | xpath=(//a[contains(text(),'yes')])[37] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[37]").click()
        # click | xpath=(//a[contains(text(),'delete')])[17] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[17]").click()
        # click | xpath=(//a[contains(text(),'yes')])[42] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[42]").click()
        # click | xpath=(//a[contains(text(),'delete')])[17] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[17]").click()
        # click | xpath=(//a[contains(text(),'yes')])[43] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[43]").click()
        # click | xpath=(//a[contains(text(),'delete')])[17] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[17]").click()
        # click | xpath=(//a[contains(text(),'yes')])[43] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[43]").click()
        # click | xpath=(//a[contains(text(),'delete')])[17] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[17]").click()
        # click | xpath=(//a[contains(text(),'yes')])[44] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[44]").click()
        # click | xpath=(//a[contains(text(),'delete')])[17] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[17]").click()
        # click | xpath=(//a[contains(text(),'yes')])[46] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[46]").click()
        # click | link=Not. Funny. | 
        driver.find_element_by_link_text("Not. Funny.").click()
        # click | xpath=(//a[contains(text(),'delete')])[12] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[12]").click()
        # click | xpath=(//a[contains(text(),'yes')])[23] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[23]").click()
        # click | xpath=(//a[contains(text(),'delete')])[11] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[11]").click()
        # click | xpath=(//a[contains(text(),'yes')])[22] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[22]").click()
        # click | xpath=(//a[contains(text(),'delete')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[10]").click()
        # click | xpath=(//a[contains(text(),'yes')])[20] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[20]").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | I'm not your fella, tio
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("I'm not your fella, tio")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | xpath=(//a[contains(text(),'delete')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[3]").click()
        # click | xpath=(//a[contains(text(),'yes')])[5] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[5]").click()
        # click | link=IRISH FOLK FURNITURE, looking better after a lick | 
        driver.find_element_by_link_text("IRISH FOLK FURNITURE, looking better after a lick").click()
        # click | link=delete | 
        driver.find_element_by_link_text("delete").click()
        # click | link=yes | 
        driver.find_element_by_link_text("yes").click()
        # click | xpath=(//a[contains(text(),'delete')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[2]").click()
        # click | xpath=(//a[contains(text(),'yes')])[4] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[4]").click()
        # click | xpath=(//a[contains(text(),'context')])[2] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[2]").click()
        # click | //form[@id='form-t1_c1blxvu47h']/div/div/p | 
        driver.find_element_by_xpath("//form[@id='form-t1_c1blxvu47h']/div/div/p").click()
        # click | //form[@id='form-t1_c1blxvu47h']/div/div/p | 
        driver.find_element_by_xpath("//form[@id='form-t1_c1blxvu47h']/div/div/p").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # type | name=text | > What if I were to say that I had a fat calf just waiting to be sacrificed on your altar?

        # Try putting the calf over the battery
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("> What if I were to say that I had a fat calf just waiting to be sacrificed on your altar?\n\nTry putting the calf over the battery")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | xpath=(//a[contains(text(),'jab-fun')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'jab-fun')])[3]").click()
        # click | //form[@id='form-t1_c0gvbx6xzg']/div/div/p/a[2] | 
        driver.find_element_by_xpath("//form[@id='form-t1_c0gvbx6xzg']/div/div/p/a[2]").click()
        # click | //form[@id='form-t1_c0gvbx6xzg']/div/div/p/a[2] | 
        driver.find_element_by_xpath("//form[@id='form-t1_c0gvbx6xzg']/div/div/p/a[2]").click()
        # click | link=context | 
        driver.find_element_by_link_text("context").click()
        # click | css=#thing_t1_c290wyr > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink | 
        driver.find_element_by_css_selector("#thing_t1_c290wyr > div.entry.unvoted > ul.flat-list.buttons > li.first > a.bylink").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[3] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[3]").click()
        # click | link=parent | 
        driver.find_element_by_link_text("parent").click()
        # type | id=source | fellow
        driver.find_element_by_id("source").clear()
        driver.find_element_by_id("source").send_keys("fellow")
        # click | //div[@id=':4c']/div | 
        driver.find_element_by_xpath("//div[@id=':4c']/div").click()
        # type | id=source | I'm not your fellow
        driver.find_element_by_id("source").clear()
        driver.find_element_by_id("source").send_keys("I'm not your fellow")
        # click | id=source | 
        driver.find_element_by_id("source").click()
        # type | id=source | I'm not your mate
        driver.find_element_by_id("source").clear()
        driver.find_element_by_id("source").send_keys("I'm not your mate")
        # click | //div[@id=':4b']/div | 
        driver.find_element_by_xpath("//div[@id=':4b']/div").click()
        # click | css=#result_box > span | 
        driver.find_element_by_css_selector("#result_box > span").click()
        # type | id=source | Níl mé your mate ciao
        driver.find_element_by_id("source").clear()
        driver.find_element_by_id("source").send_keys(u"Níl mé your mate ciao")
        # click | //div[@id=':3q']/div | 
        driver.find_element_by_xpath("//div[@id=':3q']/div").click()
        # click | id=gt-submit | 
        driver.find_element_by_id("gt-submit").click()
        # click | //div[@id=':3p']/div | 
        driver.find_element_by_xpath("//div[@id=':3p']/div").click()
        # type | id=source | Níl mé your mate, ciao
        driver.find_element_by_id("source").clear()
        driver.find_element_by_id("source").send_keys(u"Níl mé your mate, ciao")
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | And then I log in,

        # but I'm not your mate, ciao
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("And then I log in,\n\nbut I'm not your mate, ciao")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | id=RESAccountSwitcherIcon | 
        driver.find_element_by_id("RESAccountSwitcherIcon").click()
        # click | //ul[@id='RESAccountSwitcherDropdown']/li[7] | 
        driver.find_element_by_xpath("//ul[@id='RESAccountSwitcherDropdown']/li[7]").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # click | name=text | 
        driver.find_element_by_name("text").click()
        # type | name=text | Before checking out Guido is up to...
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("Before checking out Guido is up to...")
        # type | id=newtab-search-text | xkcd antigravity
        driver.find_element_by_id("newtab-search-text").clear()
        driver.find_element_by_id("newtab-search-text").send_keys("xkcd antigravity")
        # click | id=newtab-search-submit | 
        driver.find_element_by_id("newtab-search-submit").click()
        # click | link=exact:xkcd: Python | 
        driver.find_element_by_link_text("xkcd: Python").click()
        # type | name=text | Before checking out [what Guido is up to](https://xkcd.com/353/)...
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("Before checking out [what Guido is up to](https://xkcd.com/353/)...")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | link=jab-programming | 
        driver.find_element_by_link_text("jab-programming").click()
        # click | xpath=(//a[contains(text(),'delete')])[5] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[5]").click()
        # click | xpath=(//a[contains(text(),'yes')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[10]").click()
        # click | xpath=(//a[contains(text(),'delete')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[6]").click()
        # click | xpath=(//a[contains(text(),'yes')])[13] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[13]").click()
        # click | xpath=(//a[contains(text(),'delete')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[6]").click()
        # click | xpath=(//a[contains(text(),'yes')])[14] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[14]").click()
        # click | xpath=(//a[contains(text(),'delete')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[6]").click()
        # click | xpath=(//a[contains(text(),'yes')])[15] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[15]").click()
        # click | xpath=(//a[contains(text(),'delete')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[6]").click()
        # click | xpath=(//a[contains(text(),'yes')])[15] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[15]").click()
        # click | xpath=(//a[contains(text(),'delete')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[7]").click()
        # click | xpath=(//a[contains(text(),'yes')])[19] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[19]").click()
        # click | xpath=(//a[contains(text(),'delete')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[7]").click()
        # click | xpath=(//a[contains(text(),'yes')])[20] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[20]").click()
        # click | xpath=(//a[contains(text(),'delete')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[7]").click()
        # click | xpath=(//a[contains(text(),'yes')])[20] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[20]").click()
        # click | xpath=(//a[contains(text(),'delete')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[7]").click()
        # click | xpath=(//a[contains(text(),'yes')])[23] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[23]").click()
        # click | xpath=(//a[contains(text(),'delete')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[7]").click()
        # click | xpath=(//a[contains(text(),'yes')])[24] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[24]").click()
        # click | xpath=(//a[contains(text(),'delete')])[7] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[7]").click()
        # click | xpath=(//a[contains(text(),'yes')])[25] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[25]").click()
        # click | xpath=(//a[contains(text(),'delete')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[10]").click()
        # click | xpath=(//a[contains(text(),'yes')])[32] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[32]").click()
        # click | xpath=(//a[contains(text(),'delete')])[10] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[10]").click()
        # click | xpath=(//a[contains(text(),'yes')])[33] | 
        driver.find_element_by_xpath("(//a[contains(text(),'yes')])[33]").click()
        # click | css=div.dropdown.lightdrop > span.selected | 
        driver.find_element_by_css_selector("div.dropdown.lightdrop > span.selected").click()
        # click | link=top | 
        driver.find_element_by_link_text("top").click()
        # click | xpath=(//a[contains(text(),'context')])[6] | 
        driver.find_element_by_xpath("(//a[contains(text(),'context')])[6]").click()
        # click | //form[@id='form-t1_c09h1w2r67']/div/div/p | 
        driver.find_element_by_xpath("//form[@id='form-t1_c09h1w2r67']/div/div/p").click()
        # click | //form[@id='form-t1_c09h1w2r67']/div/div/p | 
        driver.find_element_by_xpath("//form[@id='form-t1_c09h1w2r67']/div/div/p").click()
        # click | css=a.edit-usertext | 
        driver.find_element_by_css_selector("a.edit-usertext").click()
        # type | name=text | > Minor don't have that much cash to loose

        # Which is why it is easier to stop them
        driver.find_element_by_name("text").clear()
        driver.find_element_by_name("text").send_keys("> Minor don't have that much cash to loose\n\nWhich is why it is easier to stop them")
        # click | css=button.save | 
        driver.find_element_by_css_selector("button.save").click()
        # click | xpath=(//a[contains(text(),'jab-programming')])[3] | 
        driver.find_element_by_xpath("(//a[contains(text(),'jab-programming')])[3]").click()
        # click | css=div.dropdown.lightdrop > span.selected | 
        driver.find_element_by_css_selector("div.dropdown.lightdrop > span.selected").click()
        # click | link=top | 
        driver.find_element_by_link_text("top").click()
        # click | xpath=(//a[contains(text(),'delete')])[100] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[100]").click()
        # click | //div[@id='thing_t1_c30f6ua']/div[2]/ul/li[7]/form/span[2] | 
        driver.find_element_by_xpath("//div[@id='thing_t1_c30f6ua']/div[2]/ul/li[7]/form/span[2]").click()
        # click | xpath=(//a[contains(text(),'no')])[213] | 
        driver.find_element_by_xpath("(//a[contains(text(),'no')])[213]").click()
        # click | xpath=(//a[contains(text(),'delete')])[231] | 
        driver.find_element_by_xpath("(//a[contains(text(),'delete')])[231]").click()
    
    def is_element_present(self, how, what):
        try: self.driver.find_element(by=how, value=what)
        except NoSuchElementException as e: return False
        return True
    
    def is_alert_present(self):
        try: self.driver.switch_to_alert()
        except NoAlertPresentException as e: return False
        return True
    
    def close_alert_and_get_its_text(self):
        try:
            alert = self.driver.switch_to_alert()
            alert_text = alert.text
            if self.accept_next_alert:
                alert.accept()
            else:
                alert.dismiss()
            return alert_text
        finally: self.accept_next_alert = True
    
    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)

if __name__ == "__main__":
    unittest.main()
