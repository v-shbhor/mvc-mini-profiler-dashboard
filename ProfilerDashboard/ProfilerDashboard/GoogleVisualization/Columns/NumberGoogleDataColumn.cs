/*
   Copyright 2009-2010 Gary Bortosky

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

namespace Bortosky.Google.Visualization.Columns
{
    using System;
    using System.Data;
    using System.Globalization;

    internal class NumberGoogleDataColumn : GoogleDataColumn
    {
        #region Constants and Fields

        private readonly CultureInfo invariantCulture;

        #endregion

        #region Constructors and Destructors

        /// 
        /// <param name="column"></param>
        internal NumberGoogleDataColumn(DataColumn column) : base(column)
        {
            invariantCulture = new CultureInfo(string.Empty);
        }

        #endregion

        #region Properties

        protected internal override string GoogleDataType
        {
            get { return "number"; }
        }

        #endregion

        #region Methods

        /// 
        /// <param name="row"></param>
        protected internal override string SerializedValue(DataRow row)
        {
            if (row[subjectColumn] is DBNull)
            {
                return "null";
            }

            switch (subjectColumn.DataType.FullName)
            {
                case "System.Decimal":
                    return ((Decimal) row[subjectColumn]).ToString(invariantCulture);
                case "System.Double":
                    return ((Double) row[subjectColumn]).ToString(invariantCulture);
                case "System.Single":
                    return ((Single) row[subjectColumn]).ToString(invariantCulture);
                default:
                    return row[subjectColumn].ToString();
            }
        }

        #endregion
    }
}