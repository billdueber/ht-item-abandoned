import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

class NS
  include NamespaceContext
  MAP = {
      'METS' => "http://www.loc.gov/METS/",
  }

  def get_prefix(*args)
    nil
  end

  def get_prefixes(*args)
    nil
  end
  def getNamespaceURI(str)
    puts "LOOKING UP '#{str}'"
    MAP[str]
  end
end

factory = XPathFactory.newInstance()
xPath = factory.newXPath()
xPath.setNamespaceContext(NS.new)
xp = xPath.compile('/METS:mets/METS:metsHdr/@RECORDSTATUS')

builderfactory = DocumentBuilderFactory.newInstance
builderfactory.setNamespaceAware(true)
builder = builderfactory.newDocumentBuilder

doc = builder.parse(File.open('spec/data/mets.xml').to_inputstream)

m = xp.evaluate( doc, XPathConstants::STRING)

puts m

require 'pry'; binding.pry

puts "All done!"
