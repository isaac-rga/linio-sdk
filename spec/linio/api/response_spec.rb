require 'spec_helper'

RSpec.describe Linio::Api::Response do
  let(:type) { 'get' }
  let(:headers) do
    {
      "date": ["Tue, 17 Sep 2019 19:16:29 GMT"],
      "content-type": ["text/xml; charset=utf-8"],
      "transfer-encoding": ["chunked"],
      "connection": ["keep-alive"],
      "server": ["nginx/1.15.3"]
    }
  end
  let(:succeeded_response) do
    {
      headers: headers,
      body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<SuccessResponse>\n  <Head>\n    <RequestId/>\n    <RequestAction>GetProducts</RequestAction>\n    <ResponseType>Products</ResponseType>\n    <Timestamp>2019-09-23T11:55:08-0500</Timestamp>\n  </Head>\n  <Body>\n    <Products>\n<Product>\n        <SellerSku>Loulu1.1-1</SellerSku>\n        <ShopSku/>\n        <ProductSin>5ZJTJ1Z16645</ProductSin>\n        <Name>Men's Patagonia Loulu -Black</Name>\n        <Variation>11.5</Variation>\n        <ParentSku>Loulu1.1-1</ParentSku>\n        <Quantity>1</Quantity>\n        <Available>1</Available>\n        <Price>1999.00</Price>\n        <SalePrice>1998.00</SalePrice>\n        <SaleStartDate>2019-09-23 00:00:00</SaleStartDate>\n        <SaleEndDate>2019-12-23 00:00:00</SaleEndDate>\n        <Status>active</Status>\n        <ProductId>018469831103</ProductId>\n        <Url/>\n        <MainImage/>\n        <Images>\n          <Image>https://sellercenter-static.linio.com.mx/9/9fb76e3905c7e461bb982f9bc15de37a.jpeg</Image>\n        </Images>\n        <Description>Dual density compression molded EVA footbed/midsole provides cushioning and comfort with support in the right places; removable for cleaning or custom footbeds. Dri-Lex backed wool footbed helps with temperature and moisture control. Linings are natural wool for temperature and moisture control. Opanka stitch bottom attachment for added strength and durability, minimizes the need for solvents and adhesives. Low cut lace up. Has a medium width, full toe box and medium arch/instep.</Description>\n        <TaxClass>IVA 0%</TaxClass>\n        <Brand>Patagonia</Brand>\n        <PrimaryCategory>Tenis casuales mujer</PrimaryCategory>\n        <Categories>Zapatos Mujer</Categories>\n        <ProductData>\n          <ShortDescription>-&lt;ul&gt;&lt;li&gt;Diseños actuales&lt;/li&gt;&lt;li&gt;Excelentes marcas&lt;/li&gt;&lt;li&gt;Producto nuevo y de calidad&lt;/li&gt;&lt;/ul&gt;-</ShortDescription>\n<ConditionType>Nuevo</ConditionType>\n          <ProductWarranty>GARANTÍA DE PRODUCTOS COMPRADOS EN EL EXTRANJERO: Los productos ofertados por un Vendedor en el extranjero tendrán Sólo Garantía de Satisfacción Linio. Ver detalle en Términos y condiciones.</ProductWarranty>\n<PackageHeight>1</PackageHeight>\n          <PackageWidth>1</PackageWidth>\n          <PackageLength>1</PackageLength>\n          <PackageWeight>1</PackageWeight>\n          <PackageContent>1 x Men's Patagonia Loulu -Black</PackageContent>\n        </ProductData>\n      </Product>\n <Product>\n        <SellerSku>Loulu1.1-1</SellerSku>\n        <ShopSku/>\n        <ProductSin>5ZJTJ1Z16645</ProductSin>\n        <Name>Men's Patagonia Loulu -Black</Name>\n        <Variation>11.5</Variation>\n        <ParentSku>Loulu1.1-1</ParentSku>\n        <Quantity>1</Quantity>\n        <Available>1</Available>\n        <Price>1999.00</Price>\n        <SalePrice>1998.00</SalePrice>\n        <SaleStartDate>2019-09-23 00:00:00</SaleStartDate>\n        <SaleEndDate>2019-12-23 00:00:00</SaleEndDate>\n        <Status>active</Status>\n        <ProductId>018469831103</ProductId>\n        <Url/>\n        <MainImage/>\n        <Images>\n          <Image>https://sellercenter-static.linio.com.mx/9/9fb76e3905c7e461bb982f9bc15de37a.jpeg</Image>\n        </Images>\n        <Description>Dual density compression molded EVA footbed/midsole provides cushioning and comfort with support in the right places; removable for cleaning or custom footbeds. Dri-Lex backed wool footbed helps with temperature and moisture control. Linings are natural wool for temperature and moisture control. Opanka stitch bottom attachment for added strength and durability, minimizes the need for solvents and adhesives. Low cut lace up. Has a medium width, full toe box and medium arch/instep.</Description>\n        <TaxClass>IVA 0%</TaxClass>\n        <Brand>Patagonia</Brand>\n        <PrimaryCategory>Tenis casuales mujer</PrimaryCategory>\n        <Categories>Zapatos Mujer</Categories>\n        <ProductData>\n          <ShortDescription>-&lt;ul&gt;&lt;li&gt;Diseños actuales&lt;/li&gt;&lt;li&gt;Excelentes marcas&lt;/li&gt;&lt;li&gt;Producto nuevo y de calidad&lt;/li&gt;&lt;/ul&gt;-</ShortDescription>\n<ConditionType>Nuevo</ConditionType>\n          <ProductWarranty>GARANTÍA DE PRODUCTOS COMPRADOS EN EL EXTRANJERO: Los productos ofertados por un Vendedor en el extranjero tendrán Sólo Garantía de Satisfacción Linio. Ver detalle en Términos y condiciones.</ProductWarranty>\n<PackageHeight>1</PackageHeight>\n          <PackageWidth>1</PackageWidth>\n          <PackageLength>1</PackageLength>\n          <PackageWeight>1</PackageWeight>\n          <PackageContent>1 x Men's Patagonia Loulu -Black</PackageContent>\n        </ProductData>\n      </Product>\n    </Products>\n  </Body>\n</SuccessResponse>\n"
    }
  end
  let(:errored_response) do
    {
      headers: headers,
      body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ErrorResponse><Head><RequestAction>GetProducts</RequestAction><ErrorType>Sender</ErrorType><ErrorCode>7</ErrorCode><ErrorMessage>E007: Login failed. Signature mismatch</ErrorMessage></Head><Body/></ErrorResponse>"
    }
  end

  describe '#process' do
    context 'when response is succeeded' do
      it do
        stub_request(:any, Linio::Api::Request.base_uri)
          .to_return(succeeded_response)
        stubed_response = HTTParty.get(Linio::Api::Request.base_uri)
        response = described_class.new(raw: stubed_response)
        response.process
        expect(response.head).not_to be_nil
        expect(response.body).not_to be_nil
      end
    end

    context 'when response is errored' do
      it do
        stub_request(:any, Linio::Api::Request.base_uri)
          .to_return(errored_response)
        stubed_response = HTTParty.get(Linio::Api::Request.base_uri)
        response = described_class.new(raw: stubed_response)
        response.process
        expect(response.error).to be_truthy
        expect(response.head).not_to be_nil
        expect(response.body).to be_nil
      end
    end
  end
end
