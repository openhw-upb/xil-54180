extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include "dataset.h"

using namespace std;


/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
Dataset::Dataset(vector<double> data, int16_t assingedClass = -1) :
	m_data(data),
	m_class(assingedClass)
{

}

/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
Dataset::~Dataset()
{
	m_data.clear();
}