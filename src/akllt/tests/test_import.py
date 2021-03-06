# coding: utf-8
import warnings
warnings.simplefilter('ignore')

import pkg_resources
import pathlib

from django.test.testcases import TransactionTestCase
from django.test import TestCase
from homophony import BrowserTestCase, Browser
from wagtail.wagtailcore.models import Page

from akllt.models import StandardPage


def import_pages(directory):
    assert pathlib.Path(directory).exists()


class SmokeTest(TransactionTestCase):

    def test_nothing(self):
        self.client.get('/')


class FoobarTestCase(BrowserTestCase):

    def test_home(self):
        browser = Browser()
        browser.open('http://testserver')
        browser.getLink('Naujienos').click()
        self.assertEquals(browser.title, 'Atviras Kodas Lietuvai')


class ImportTestCase(BrowserTestCase, TestCase):

    def test_import(self):
        import_pages(pkg_resources
                     .resource_filename('akllt', 'tests/fixtures/pages'))
        browser = Browser()
        browser.open('http://testserver')
        browser.getLink('Apie').click()
        # expected_content = pkg_resources.resource_string(
        #     'akllt', 'test_data/pages/apie.html')
        # self.assertTrue(expected_content in browser.contents)

    def test_create_page(self):
        self.homepage = Page.objects.get(id=2)
        self.homepage.add_child(instance=StandardPage(
            title='Atviras kodas Lietuvai',
            intro='Atviras kodas Lietuvai',
            body='Turinys',
            slug='atviras-kodas-lietuvai',
            live=True))
        Browser('http://testserver/atviras-kodas-lietuvai/')

    def test_import_news(self):
        import_news(pkg_resources
                    .resource_filename('akllt', 'tests/fixtures/naujienos'))


def import_news(directory):
    path = pathlib.Path(directory)
    assert path.exists()
    for item in path.iterdir():
        pass
        #print item
